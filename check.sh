#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="${TMPDIR:-/tmp}/dotfiles-check.$$"
PASSED=0
FAILED=0
FAILURES=()

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

banner() {
  cat <<'EOF'

+----------------------------------------------------------------+
|                  ____        __  _____ __                      |
|                 / __ \____  / /_/ __(_) /__  _____             |
|                / / / / __ \/ __/ /_/ / / _ \/ ___/             |
|               / /_/ / /_/ / /_/ __/ / /  __(__  )              |
|              /_____/\____/\__/_/ /_/_/\___/____/               |
|                                                                |
|                      dotfiles health check                     |
+----------------------------------------------------------------+
EOF
}

info() {
  printf '[info] %s\n' "$*"
}

ok() {
  printf '[ok] %s\n' "$*"
}

fail() {
  printf '[fail] %s\n' "$*" >&2
}

step() {
  printf '\n==> %s\n' "$*"
}

run_check() {
  local name="$1"
  shift

  step "$name"
  printf '$'
  printf ' %q' "$@"
  printf '\n'

  if "$@"; then
    ok "$name"
    PASSED=$((PASSED + 1))
  else
    fail "$name"
    FAILURES+=("$name")
    FAILED=$((FAILED + 1))
  fi
}

render_and_check_bash() {
  local source_path="$1"
  local output_path="$TMP_DIR/$(basename "$source_path" .tmpl).sh"

  step "Template bash syntax: $source_path"
  info "render: chezmoi execute-template < $source_path > $output_path"
  if ! chezmoi execute-template < "$source_path" > "$output_path"; then
    fail "render failed: $source_path"
    FAILURES+=("render $source_path")
    FAILED=$((FAILED + 1))
    return
  fi

  info "syntax: bash -n $output_path"
  if bash -n "$output_path"; then
    ok "Template bash syntax: $source_path"
    PASSED=$((PASSED + 1))
  else
    fail "Template bash syntax: $source_path"
    FAILURES+=("bash -n $source_path")
    FAILED=$((FAILED + 1))
  fi
}

render_and_check_zsh() {
  local source_path="$1"
  local output_path="$TMP_DIR/$(basename "$source_path" .tmpl).zsh"

  step "Template zsh syntax: $source_path"
  info "render: chezmoi execute-template < $source_path > $output_path"
  if ! chezmoi execute-template < "$source_path" > "$output_path"; then
    fail "render failed: $source_path"
    FAILURES+=("render $source_path")
    FAILED=$((FAILED + 1))
    return
  fi

  info "syntax: zsh -n $output_path"
  if zsh -n "$output_path"; then
    ok "Template zsh syntax: $source_path"
    PASSED=$((PASSED + 1))
  else
    fail "Template zsh syntax: $source_path"
    FAILURES+=("zsh -n $source_path")
    FAILED=$((FAILED + 1))
  fi
}

summary() {
  printf '\n'
  printf '+----------------------------------------------------------------+\n'
  printf '| Summary                                                        |\n'
  printf '+----------------------------------------------------------------+\n'
  printf 'passed : %s\n' "$PASSED"
  printf 'failed : %s\n' "$FAILED"

  if [[ "$FAILED" -gt 0 ]]; then
    printf '\nFailures:\n'
    printf '  - %s\n' "${FAILURES[@]}"
    return 1
  fi

  printf '\nAll checks passed.\n'
}

cd "$ROOT_DIR" || exit 1
mkdir -p "$TMP_DIR"

banner
info "repo root : $ROOT_DIR"
info "temp dir  : $TMP_DIR"
info "date      : $(date -Iseconds)"

run_check "install.sh bash syntax" bash -n install.sh
run_check "git whitespace check" git diff --check

for script in .chezmoiscripts/*.sh.tmpl; do
  render_and_check_bash "$script"
done

render_and_check_zsh dot_config/zsh/proxy.zsh.tmpl

run_check "chezmoi dry-run apply" chezmoi apply --dry-run

summary
