#!/usr/bin/env bash
set -euo pipefail

repo="${CHEZMOI_REPO:-https://github.com/Jerry-FaGe/dotfiles.git}"
mode="--apply"
age_key_path="${CHEZMOI_AGE_KEY_PATH:-$HOME/.config/chezmoi/key.txt}"
age_key_file="${CHEZMOI_AGE_KEY_FILE:-}"
machine_type="${CHEZMOI_MACHINE_TYPE:-}"
chezmoi_global_args=()
selected_machine_type=""

print_banner() {
  cat <<'EOF'

dotfiles installer
==================
EOF
}

info() {
  printf '[info] %s\n' "$*"
}

ok() {
  printf '[ok] %s\n' "$*"
}

warn() {
  printf '[warn] %s\n' "$*" >&2
}

error() {
  printf '[error] %s\n' "$*" >&2
}

step() {
  printf '\n==> %s\n' "$*"
}

usage() {
  cat <<'EOF'
Usage: ./install.sh [--one-shot|--no-apply|--dry-run] [--repo URL] [--age-key-file PATH] [--machine-type TYPE]

Options:
  --one-shot     Apply dotfiles, then remove chezmoi's source/config state.
  --no-apply     Run chezmoi init only; do not apply dotfiles yet.
  --dry-run      Run chezmoi in dry-run mode.
  --repo URL     Override the dotfiles repository URL.
  --age-key-file PATH
                 Copy an existing age identity to ~/.config/chezmoi/key.txt.
  --machine-type TYPE
                 Set machine type for templates: wsl, server, or desktop.
  -h, --help     Show this help.

Environment:
  CHEZMOI_REPO           Default repository URL when --repo is not provided.
  CHEZMOI_AGE_KEY_FILE   Path to an existing age identity file.
  CHEZMOI_AGE_KEY_PATH   Destination path for the age identity file.
  CHEZMOI_MACHINE_TYPE   Machine type for templates: wsl, server, or desktop.
EOF
}

detect_machine_type() {
  if [[ -n "$machine_type" ]]; then
    case "$machine_type" in
      wsl|server|desktop)
        printf '%s\n' "$machine_type"
        return 0
        ;;
      *)
        error "machine type must be one of: wsl, server, desktop"
        exit 2
        ;;
    esac
  fi

  if [[ "$(uname -s)" != "Linux" ]]; then
    printf 'desktop\n'
    return 0
  fi

  local kernel_release=""
  kernel_release="$(uname -r | tr '[:upper:]' '[:lower:]')"
  if [[ "$kernel_release" == *microsoft* || "$kernel_release" == *wsl* ]]; then
    printf 'wsl\n'
    return 0
  fi

  if [[ -n "${XDG_CURRENT_DESKTOP:-}" || -n "${DESKTOP_SESSION:-}" ]]; then
    printf 'desktop\n'
    return 0
  fi

  printf 'server\n'
}

install_age_key_file() {
  local source_path="$1"

  if [[ ! -f "$source_path" ]]; then
    error "age key file does not exist: $source_path"
    exit 1
  fi

  mkdir -p "$(dirname "$age_key_path")"
  if [[ "$(realpath -m "$source_path")" == "$(realpath -m "$age_key_path")" ]]; then
    chmod 600 "$age_key_path"
    ok "using existing age identity: $age_key_path"
    return 0
  fi

  install -m 600 "$source_path" "$age_key_path"
  ok "installed age identity: $age_key_path"
}

prompt_for_age_key() {
  if [[ ! -r /dev/tty ]]; then
    return 1
  fi

  local answer=""
  printf '[warn] age identity not found at %s. Paste it now? [y/N] ' "$age_key_path" >/dev/tty
  read -r answer </dev/tty

  case "$answer" in
    y|Y|yes|YES)
      ;;
    *)
      return 1
      ;;
  esac

  local key=""
  local tty_state=""
  tty_state="$(stty -g </dev/tty)"
  printf 'Paste AGE-SECRET-KEY line: ' >/dev/tty
  stty -echo </dev/tty
  if ! read -r key </dev/tty; then
    stty "$tty_state" </dev/tty
    return 1
  fi
  stty "$tty_state" </dev/tty
  printf '\n' >/dev/tty

  if [[ ! "$key" == AGE-SECRET-KEY-* ]]; then
    error "pasted value does not look like an age identity"
    exit 1
  fi

  mkdir -p "$(dirname "$age_key_path")"
  umask 077
  printf '%s\n' "$key" >"$age_key_path"
  chmod 600 "$age_key_path"
  ok "installed age identity: $age_key_path"
}

ensure_age_key() {
  step "Checking age identity"

  if [[ -f "$age_key_path" ]]; then
    chmod 600 "$age_key_path"
    ok "found age identity: $age_key_path"
    return 0
  fi

  if [[ -n "$age_key_file" ]]; then
    install_age_key_file "$age_key_file"
    return 0
  fi

  if prompt_for_age_key; then
    return 0
  fi

  if [[ -z "$mode" ]]; then
    cat >&2 <<EOF
[warn] age identity was not configured.
Run with --age-key-file PATH or create $age_key_path before chezmoi apply.
EOF
    return 0
  fi

  cat >&2 <<EOF
[error] age identity is required before applying encrypted files.

Options:
  ./install.sh --age-key-file /path/to/key.txt
  CHEZMOI_AGE_KEY_FILE=/path/to/key.txt ./install.sh
  install -m 600 /path/to/key.txt $age_key_path
EOF
  exit 1
}

run_chezmoi() {
  step "Running chezmoi"
  info "repository: $repo"
  info "machine type: $selected_machine_type"
  if [[ ${#chezmoi_global_args[@]} -gt 0 ]]; then
    info "global args: ${chezmoi_global_args[*]}"
  fi
  info "init args: ${args[*]}"

  if command -v chezmoi >/dev/null 2>&1; then
    ok "using existing chezmoi: $(command -v chezmoi)"
    exec chezmoi "${chezmoi_global_args[@]}" "${args[@]}"
  fi

  info "chezmoi not found; installing to $HOME/.local/bin"
  mkdir -p "$HOME/.local/bin"
  sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b "$HOME/.local/bin"
  ok "installed chezmoi: $HOME/.local/bin/chezmoi"
  exec "$HOME/.local/bin/chezmoi" "${chezmoi_global_args[@]}" "${args[@]}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --one-shot)
      mode="--one-shot"
      shift
      ;;
    --no-apply)
      mode=""
      shift
      ;;
    --dry-run)
      chezmoi_global_args+=(--dry-run)
      shift
      ;;
    --repo)
      if [[ $# -lt 2 || -z "$2" ]]; then
        error "--repo requires a URL"
        exit 2
      fi
      repo="$2"
      shift 2
      ;;
    --age-key-file)
      if [[ $# -lt 2 || -z "$2" ]]; then
        error "--age-key-file requires a path"
        exit 2
      fi
      age_key_file="$2"
      shift 2
      ;;
    --machine-type)
      if [[ $# -lt 2 || -z "$2" ]]; then
        error "--machine-type requires one of: wsl, server, desktop"
        exit 2
      fi
      machine_type="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      error "unknown argument: $1"
      usage >&2
      exit 2
      ;;
  esac
done

if ! command -v curl >/dev/null 2>&1; then
  error "curl is required. Install it first, then rerun this script."
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  error "git is required. Install it first, then rerun this script."
  exit 1
fi

print_banner
step "Checking prerequisites"
ok "curl: $(command -v curl)"
ok "git: $(command -v git)"

args=(init)
if [[ -n "$mode" ]]; then
  args+=("$mode")
fi
selected_machine_type="$(detect_machine_type)"
args+=(--promptDefaults --promptString "machine_type=$selected_machine_type" "$repo")

ensure_age_key

run_chezmoi
