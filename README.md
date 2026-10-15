mc_log_ui
====

mc_log_ui is a python/Qt GUI for interacting with `mc_rtc` log files, or any `CSV` file.

# Nix

To use with Nix:

- Run with `nix run .#py-mc-log-ui`
- Develop with `nix develop`


# Using uv

[uv](https://github.com/astral-sh/uv) is a fast Python package manager. To use mc_log_ui with uv:

1. Install uv (if not already installed):

   ```sh
   curl -Ls https://astral.sh/uv/install.sh | sh
   ```

2. Activate a virtual environment. Optional: If you wish to have named robot joints, this needs to be the same venv as `mc_rtc`.
3. Run `mc_log_ui` with  `uv run mc_log_ui`
   Run `plot_logs` with `uv run plot_logs`

See the [uv documentation](https://github.com/astral-sh/uv) for more details.


# Debian packaging

The active Debian packaging metadata now lives in the top-level `debian/`
directory.

Release/version workflow:

- install release tooling with `uv tool install jrl-cmakemodules-scripts --from git+https://github.com/jrl-umi3218/jrl-cmakemodules.git#subdirectory=v2/scripts`
- check version coherence with `jrl-release --check-version`
- update `debian/changelog` manually on release with `jrl-release --bump [patch|minor|major]`

## Build in Docker (recommended)

This path is the same one used by GitHub Actions and is the easiest way to
debug packaging issues locally.

```sh
./tools/debian/build-in-docker.sh
```

Defaults:

- base image: `ubuntu:noble`
- artifacts directory: `build/debian-artifacts/noble/`

Useful overrides:

```sh
DEB_BASE_IMAGE=ubuntu:24.04 DEB_SUITE=noble ./tools/debian/build-in-docker.sh
```

## Build on a local Ubuntu/Debian host

Install build-dependencies from the committed `debian/control`, then build the
package directly from the checkout:

```sh
sudo bash tools/debian/install-build-deps.sh
bash tools/debian/build-package.sh
```

## Manual checks

After a build completes, inspect the generated artifacts manually:

```sh
ls build/debian-artifacts/noble/
dpkg-deb --info build/debian-artifacts/noble/*.deb
dpkg-deb --contents build/debian-artifacts/noble/*.deb
```

To smoke-test the installed package on a matching system:

```sh
sudo apt install ./build/debian-artifacts/noble/*.deb
python3 -c "import mc_log_ui; from pathlib import Path; print(Path(mc_log_ui.get_icon()).exists())"
command -v mc_log_ui
command -v plot_logs
```
