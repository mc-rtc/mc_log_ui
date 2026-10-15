#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/debian/common.sh
source "${script_dir}/common.sh"

docker build \
  --build-arg BASE_IMAGE="${DEB_BASE_IMAGE}" \
  --file "${REPO_ROOT}/packaging/docker/debian-package.Dockerfile" \
  --tag "${DEB_DOCKER_IMAGE_TAG}" \
  "${REPO_ROOT}"

docker run --rm \
  --env DEB_SUITE="${DEB_SUITE}" \
  --env DEB_OUTPUT_DIR="/workspace/repo/build/debian-artifacts/${DEB_SUITE}" \
  --volume "${REPO_ROOT}:/workspace/repo" \
  --workdir /workspace/repo \
  "${DEB_DOCKER_IMAGE_TAG}" \
  bash -lc '
    bash tools/debian/install-build-deps.sh &&
    bash tools/debian/build-package.sh
  '
