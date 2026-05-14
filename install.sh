#!/usr/bin/env bash
set -euo pipefail

repo="${CHEZMOI_REPO:-https://github.com/Jerry-FaGe/dotfiles.git}"
mode="--apply"

usage() {
  cat <<'EOF'
Usage: ./install.sh [--one-shot|--no-apply] [--repo URL]

Options:
  --one-shot     Apply dotfiles, then remove chezmoi's source/config state.
  --no-apply     Run chezmoi init only; do not apply dotfiles yet.
  --repo URL     Override the dotfiles repository URL.
  -h, --help     Show this help.

Environment:
  CHEZMOI_REPO   Default repository URL when --repo is not provided.
EOF
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
    --repo)
      if [[ $# -lt 2 || -z "$2" ]]; then
        echo "ERROR: --repo requires a URL" >&2
        exit 2
      fi
      repo="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: curl is required. Install it first, then rerun this script." >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required. Install it first, then rerun this script." >&2
  exit 1
fi

args=(init)
if [[ -n "$mode" ]]; then
  args+=("$mode")
fi
args+=("$repo")

if [[ ! -f "$HOME/.config/chezmoi/key.txt" ]]; then
  cat >&2 <<'EOF'
WARN: age identity not found at ~/.config/chezmoi/key.txt.
Encrypted files require this key before apply can fully succeed.

Prepare it with:
  mkdir -p ~/.config/chezmoi
  install -m 600 /path/to/key.txt ~/.config/chezmoi/key.txt

Or paste a key manually:
  mkdir -p ~/.config/chezmoi
  umask 077
  cat > ~/.config/chezmoi/key.txt

Then rerun:
EOF
  printf '  sh -c "$(curl -fsLS https://get.chezmoi.io)" --' >&2
  printf ' %q' "${args[@]}" >&2
  printf '\n' >&2
fi

exec sh -c "$(curl -fsLS https://get.chezmoi.io)" -- "${args[@]}"
