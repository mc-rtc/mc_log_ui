#!/usr/bin/env bash

set -euo pipefail

repo_root() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cd "${script_dir}/../.." && pwd
}

readonly REPO_ROOT="${REPO_ROOT:-$(repo_root)}"
readonly SOURCE_PACKAGE="${SOURCE_PACKAGE:-mc-log-ui}"
readonly DEB_SUITE="${DEB_SUITE:-noble}"
readonly DEB_OUTPUT_DIR="${DEB_OUTPUT_DIR:-${REPO_ROOT}/build/debian-artifacts/${DEB_SUITE}}"
readonly DEB_BASE_IMAGE="${DEB_BASE_IMAGE:-ubuntu:${DEB_SUITE}}"
readonly DEB_DOCKER_IMAGE_TAG="${DEB_DOCKER_IMAGE_TAG:-${SOURCE_PACKAGE}-debian-builder:${DEB_SUITE}}"
