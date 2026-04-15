#!/usr/bin/env bash

detect_sourced() {
  if [[ -n "${BASH_VERSION:-}" ]]; then
    [[ "${BASH_SOURCE[0]:-}" != "${0:-}" ]] && return 0
    return 1
  fi

  if [[ -n "${ZSH_VERSION:-}" ]]; then
    case "${ZSH_EVAL_CONTEXT:-}" in
      *:file) return 0 ;;
    esac
  fi

  return 1
}

IS_SOURCED=0
if detect_sourced; then
  IS_SOURCED=1
fi

# Avoid changing the parent shell behavior when this file is sourced.
if [[ "$IS_SOURCED" -eq 0 ]]; then
  set -euo pipefail
fi

detect_script_path() {
  if [[ -n "${BASH_SOURCE:-}" ]]; then
    printf '%s\n' "${BASH_SOURCE[0]}"
    return
  fi

  if [[ -n "${ZSH_VERSION:-}" ]]; then
    printf '%s\n' "${(%):-%N}"
    return
  fi

  printf '%s\n' "$0"
}

SCRIPT_PATH="$(detect_script_path)"
ROOT_DIR="$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd)"
ENV_FILE="$ROOT_DIR/.env"
DESKTOP_BIN="/Applications/Codex.app/Contents/MacOS/Codex"

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_CYAN=$'\033[36m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
  C_MAGENTA=$'\033[35m'
else
  C_RESET=""
  C_BOLD=""
  C_CYAN=""
  C_GREEN=""
  C_YELLOW=""
  C_RED=""
  C_MAGENTA=""
fi

say() { printf '%s\n' "$1"; }
info() { say "${C_CYAN}${1}${C_RESET}"; }
ok() { say "${C_GREEN}${1}${C_RESET}"; }
warn() { say "${C_YELLOW}${1}${C_RESET}"; }
error() { say "${C_RED}${1}${C_RESET}"; }
title() { say "${C_BOLD}${C_MAGENTA}${1}${C_RESET}"; }

# Functions return to caller when sourced, but terminate process when executed.
finish() {
  local code="${1:-0}"
  if [[ "$IS_SOURCED" -eq 1 ]]; then
    return "$code"
  fi
  exit "$code"
}

has_cli() { command -v codex >/dev/null 2>&1; }
has_desktop() { [[ -x "$DESKTOP_BIN" ]]; }

cli_status_label() {
  if has_cli; then
    printf '%s\n' "${C_GREEN}[available]${C_RESET}"
  else
    printf '%s\n' "${C_RED}[not installed]${C_RESET}"
  fi
}

desktop_status_label() {
  if has_desktop; then
    printf '%s\n' "${C_GREEN}[available]${C_RESET}"
  else
    printf '%s\n' "${C_RED}[not installed]${C_RESET}"
  fi
}

terminal_width() {
  local cols
  cols=80
  if command -v tput >/dev/null 2>&1; then
    cols="$(tput cols 2>/dev/null || printf '80')"
  fi
  if [[ -z "$cols" || "$cols" -lt 40 ]]; then
    cols=80
  fi
  printf '%s\n' "$cols"
}

print_centered() {
  local text="$1"
  local color="${2:-}"
  local cols pad
  cols="$(terminal_width)"
  pad=$(( (cols - ${#text}) / 2 ))
  if (( pad < 0 )); then
    pad=0
  fi
  printf '%*s%s%s%s\n' "$pad" "" "$color" "$text" "$C_RESET"
}

print_centered_block() {
  local color="$1"
  shift
  local cols max_len pad line
  cols="$(terminal_width)"
  max_len=0

  for line in "$@"; do
    if (( ${#line} > max_len )); then
      max_len=${#line}
    fi
  done

  pad=$(( (cols - max_len) / 2 ))
  if (( pad < 0 )); then
    pad=0
  fi

  for line in "$@"; do
    printf '%*s%s%s%s\n' "$pad" "" "$color" "$line" "$C_RESET"
  done
}

print_hash_rule() {
  local cols
  cols="$(terminal_width)"
  print_centered "$(printf '%*s' "$cols" '' | tr ' ' '#')" "$C_CYAN"
}

show_datadoe_banner() {
  print_hash_rule
  print_centered_block "$C_CYAN" \
    "____    _  _____   _    ____   ___  _____   __  __  ____  ____" \
    "|  _ \\  / \\|_   _| / \\  |  _ \\ / _ \\| ____| |  \\/  |/ ___||  _ \\" \
    "| | | |/ _ \\ | |  / _ \\ | | | | | | |  _|   | |\\/| | |    | |_) |" \
    "| |_| / ___ \\| | / ___ \\| |_| | |_| | |___  | |  | | |___ |  __/" \
    "|____/_/   \\_\\_|/_/   \\_\\____/ \\___/|_____| |_|  |_|\\____||_|"
  print_hash_rule
}

show_intro() {
  show_datadoe_banner
  info "Calibrating coffee-to-code ratio..."
  info "Warming up MCP engines..."
  ok "Secret key loaded from .env. All systems go."
}

show_goodbye_banner() {
  say ""
  title "============================================"
  title " Thanks for using DataDoe MCP with Codex!"
  title "============================================"
  ok "Desktop session ended. Have a productive day."
}

print_cli_missing_hint() {
  warn "Codex CLI is not installed or not available on PATH."
  say "Install it and then retry, for example:"
  say "  npm install -g @openai/codex"
}

print_desktop_missing_hint() {
  warn "Codex Desktop app binary is not available."
  say "Expected path:"
  say "  ${C_BOLD}$DESKTOP_BIN${C_RESET}"
  say "Install Codex Desktop or update DESKTOP_BIN in this script."
}

usage() {
  show_datadoe_banner
  say ""
  title "DataDoe Codex Launcher Manual"
  say "----------------------------------------"
  info "Usage:"
  say "  ./scripts/start-codex.sh"
  say "  ./scripts/start-codex.sh --cli"
  say "  ./scripts/start-codex.sh --desktop"
  say "  ./scripts/start-codex.sh --check"
  say ""
  info "Options:"
  say "  --cli      Start Codex CLI after loading .env"
  say "  --desktop  Start Codex Desktop app binary after loading .env"
  say "  --check    Validate .env loading without launching Codex"
  say "  -h, --help Show this help message"
  say ""
  info "Tips:"
  say "  - Run without args for interactive mode."
  say "  - Keep secrets in .env, not in .codex/config.toml."
}

load_env() {
  if [[ ! -f "$ENV_FILE" ]]; then
    error "Missing .env at $ENV_FILE"
    warn "Create it from .env.example and set DATADOE_MCP_KEY."
    return 1
  fi

  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a

  if [[ -z "${DATADOE_MCP_KEY:-}" ]]; then
    error "DATADOE_MCP_KEY is empty after loading .env."
    return 1
  fi
}

start_cli() {
  if ! has_cli; then
    error "Cannot launch Codex CLI."
    print_cli_missing_hint
    return 1
  fi

  ok "Launching Codex CLI. Mission accepted."
  cd "$ROOT_DIR"
  exec codex
}

start_desktop() {
  local app_exit_code

  if ! has_desktop; then
    error "Cannot launch Codex Desktop app."
    print_desktop_missing_hint
    return 1
  fi

  ok "Launching Codex Desktop app binary."
  cd "$ROOT_DIR"

  # Keep this script alive so we can print a goodbye banner after app exit.
  "$DESKTOP_BIN"
  app_exit_code=$?
  if [[ "$app_exit_code" -ne 0 ]]; then
    warn "Codex Desktop exited with code $app_exit_code."
  fi
  show_goodbye_banner
  return "$app_exit_code"
}

handle_menu_choice() {
  local choice="$1"

  case "$choice" in
    1)
      if has_cli; then
        start_cli
      else
        error "You selected Codex CLI, but it is unavailable."
        print_cli_missing_hint
      fi
      ;;
    2)
      if has_desktop; then
        start_desktop
      else
        error "You selected Codex Desktop, but it is unavailable."
        print_desktop_missing_hint
      fi
      ;;
    3)
      warn "Launch aborted. No worries, your key remains safe."
      return 0
      ;;
    *)
      error "Unknown option '$choice'. Please run again and pick 1, 2, or 3."
      ;;
  esac

  return 1
}

choose_mode() {
  local choice

  while true; do
    say ""
    say "${C_YELLOW}Choose launch mode:${C_RESET}"
    say "  ${C_BOLD}1${C_RESET}) Codex CLI $(cli_status_label)"
    say "  ${C_BOLD}2${C_RESET}) Codex Desktop app $(desktop_status_label)"
    say "  ${C_BOLD}3${C_RESET}) Exit"
    printf "${C_CYAN}Enter option [1-3]: ${C_RESET}"

    if ! read -r choice; then
      warn "No input received. Exiting launcher."
      return 0
    fi

    if handle_menu_choice "$choice"; then
      return 0
    fi
  done
}

main() {
  case "${1:-}" in
    -h|--help)
      usage
      if [[ "$IS_SOURCED" -eq 1 ]]; then
        warn "Tip: run this launcher as './scripts/start-codex.sh' (without source)."
      fi
      return 0
      ;;
  esac

  if ! load_env; then
    return 1
  fi
  show_intro

  case "${1:-}" in
    --cli) start_cli ;;
    --desktop) start_desktop ;;
    --check)
      ok "Check complete: DATADOE_MCP_KEY is loaded and ready."
      return 0
      ;;
    "") choose_mode ;;
    *)
      error "Unknown option: ${1:-}"
      usage
      return 1
      ;;
  esac
}

main "$@"
finish $?
