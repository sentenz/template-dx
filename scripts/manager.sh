#!/bin/bash
#
# Bootstrap Manager for the local environment lifecycle.

# -u: treat unset variables
# -o pipefail: return value of a pipeline
set -uo pipefail

# Include Scripts

source "$(dirname "${BASH_SOURCE[0]}")/shell/pkg.sh"

# Package Definitions

## Bootstrap prerequisites (platform essentials)
readonly -A BOOTSTRAP_APT_PACKAGES=(
  ["make"]=""
  ["git"]=""
  ["jq"]=""
  ["bash"]=""
  ["ca-certificates"]=""
  ["go"]=""
)

readonly -A BOOTSTRAP_NPM_PACKAGES=(
  ["skills"]="1.5.1"
)

## Setup dependencies (development tools)
readonly -A SETUP_GO_PACKAGES=(
  ["go.mozilla.org/sops/cmd/sops"]="3.4.0"
)

readonly -A SETUP_NPM_PACKAGES=(
  ["lefthook"]="2.1.6"
)

## Teardown packages (reverse order of bootstrap and setup)
readonly -A TEARDOWN_NPM_PACKAGES=(
  ["lefthook"]=""
)

readonly -A TEARDOWN_GO_PACKAGES=(
  ["sops"]=""
)

readonly -A TEARDOWN_APT_PACKAGES=(
  ["make"]=""
  ["git"]=""
  ["jq"]=""
  ["bash"]=""
  ["ca-certificates"]=""
  ["go"]=""
)

# Workflow Functions

function cmd_bootstrap() {
  local -i retval=0

  pkg_apt_install_list BOOTSTRAP_APT_PACKAGES
  ((retval |= $?))

  pkg_apt_clean
  ((retval |= $?))

  pkg_npm_install_list BOOTSTRAP_NPM_PACKAGES
  ((retval |= $?))

  pkg_npm_clean
  ((retval |= $?))

  return "${retval}"
}

function cmd_setup() {
  local -i retval=0

  pkg_go_install_list SETUP_GO_PACKAGES
  ((retval |= $?))

  pkg_go_clean
  ((retval |= $?))

  pkg_npm_install_list SETUP_NPM_PACKAGES
  ((retval |= $?))

  pkg_npm_clean
  ((retval |= $?))

  return "${retval}"
}

function cmd_teardown() {
  # NOTE Use reversed order of bootstrap and setup for tearing down the environment
  local -i retval=0

  pkg_npm_uninstall_list TEARDOWN_NPM_PACKAGES
  ((retval |= $?))

  pkg_npm_clean
  ((retval |= $?))

  pkg_go_uninstall_list TEARDOWN_GO_PACKAGES
  ((retval |= $?))

  pkg_go_clean
  ((retval |= $?))

  pkg_apt_uninstall_list TEARDOWN_APT_PACKAGES
  ((retval |= $?))

  pkg_apt_clean
  ((retval |= $?))

  return "${retval}"
}

# Control Flow Logic

function usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") <command>

Bootstrap Manager for the local environment lifecycle.

Commands:
  bootstrap   Initialize the workspace with essential prerequisites
  setup       Install development dependencies
  teardown    Remove development artifacts and restore the host
  all         Run bootstrap followed by setup

Options:
  -h, --help  Show this help message and exit
EOF
}

function main() {
  local command="${1:-}"
  shift || true

  case "${command}" in
    bootstrap)
      cmd_bootstrap
      ;;
    setup)
      cmd_setup
      ;;
    teardown)
      cmd_teardown
      ;;
    all)
      local -i retval=0

      cmd_bootstrap
      ((retval |= $?))

      cmd_setup
      ((retval |= $?))

      return "${retval}"
      ;;
    -h | --help | help)
      usage
      return 0
      ;;
    "")
      log_error "command is required"
      usage >&2
      return 1
      ;;
    *)
      log_error "unknown command: '${command}'"
      usage >&2
      return 1
      ;;
  esac
}

main "${@}"
exit "${?}"
