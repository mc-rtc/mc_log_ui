#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/debian/common.sh
source "${script_dir}/common.sh"

find "$(dirname "${REPO_ROOT}")" -maxdepth 1 -type f -name "${SOURCE_PACKAGE}_*" -delete

(
  cd "${REPO_ROOT}"
  dpkg-buildpackage -us -uc -b
)

mkdir -p "${DEB_OUTPUT_DIR}"
find "${DEB_OUTPUT_DIR}" -maxdepth 1 -type f -name "${SOURCE_PACKAGE}_*" -delete

find "$(dirname "${REPO_ROOT}")" -maxdepth 1 -type f \
  \( -name "*.deb" -o -name "*.buildinfo" -o -name "*.changes" \) \
  -exec cp -f {} "${DEB_OUTPUT_DIR}/" \;

printf 'Debian artifacts copied to %s\n' "${DEB_OUTPUT_DIR}"
