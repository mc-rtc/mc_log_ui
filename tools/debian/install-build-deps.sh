#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/debian/common.sh
source "${script_dir}/common.sh"

apt-get update
apt-get install --yes --no-install-recommends devscripts equivs
mk-build-deps \
  --install \
  --remove \
  --tool "apt-get --yes --no-install-recommends" \
  "${REPO_ROOT}/debian/control"
