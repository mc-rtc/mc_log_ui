# mc_log_ui Copilot instructions

## Build, run, test, and lint commands

- **Primary Nix workflow**
  - `nix develop`
  - `nix run .#py-mc-log-ui`
  - `nix shell .#py-mc-log-ui -c mc_log_ui`
  - `nix shell .#py-mc-log-ui -c plot_logs`
  - CI-equivalent checks: `nix flake check -L` and `nix build -L .#py-mc-log-ui`
- **Primary uv workflow**
  - `uv run mc_log_ui`
  - `uv run plot_logs`
- **Lint / formatting**
  - Full repo hooks: `pre-commit run --all-files`
  - Python-only lint: `ruff check .`
  - Python-only format: `ruff format .`
  - Single-file lint/format: `ruff check mc_log_ui/mc_log_ui.py` and `ruff format mc_log_ui/mc_log_ui.py`
- **Debian packaging**
  - Docker path used by CI: `bash tools/debian/build-in-docker.sh`
  - Host packaging flow: `sudo bash tools/debian/install-build-deps.sh && bash tools/debian/build-package.sh`
  - Build artifacts are copied to `build/debian-artifacts/<suite>/`, defaulting to `build/debian-artifacts/noble/`
  - Release/version workflow: install `jrl-release` via `uv tool install jrl-cmakemodules-scripts --from git+https://github.com/jrl-umi3218/jrl-cmakemodules.git#subdirectory=v2/scripts`, check with `jrl-release --check-version`, and update `debian/changelog` with `jrl-release --bump [patch|minor|major]`
- **Automated tests**
  - There is no committed Python test suite in this repository. The closest project-wide validation in CI is `nix flake check -L` plus `nix build -L .#py-mc-log-ui`.

## High-level architecture

- `mc_log_ui/__main__.py` is the GUI entry point. It creates the `QApplication`, instantiates `MCLogUI`, and auto-loads any log paths passed on the command line.
- `mc_log_ui/mc_log_ui.py` is the top-level application controller. It owns log loading, compare-mode merging, menus, shortcuts, user-plot persistence, color/grid configuration, and optional robot integration through `mc_rbdyn`.
- `mc_log_ui/mc_log_tab.py` is the per-tab controller. Each tab can switch between time, XY, and 3D plotting modes while keeping the same underlying dataset. It also builds the tree selectors from log keys and reconstructs saved plots through `MakePlot` / `UserFigure`.
- `mc_log_ui/mc_log_plotcanvas.py` is the plotting engine. `PlotFigure` and `PlotCanvasWithToolbar` wrap Matplotlib state for dual-axis time plots, XY plots, 3D plots, polygon overlays, axis locking, generated ranges, and animation/export actions.
- `mc_log_ui/mc_log_types.py` defines the lightweight persisted plotting types (`LineStyle`, `GraphLabels`, `ColorsSchemeConfiguration`, `UserPlot`). `mc_log_ui/mc_log_data.py` wraps the shared data dictionary in a `QObject` so UI updates can be signaled.
- `mc_log_ui/plot_logs.py` is a non-interactive exporter. It reuses `read_log`, `load_UserPlots`, and `MCLogTab.UserFigure` to render saved plots directly to image files.
- `mc_log_ui/ui/` contains checked-in generated Qt UI Python modules, and `mc_log_ui/ui/__init__.py` is the import shim used by the rest of the app.
- Debian packaging now lives in the top-level `debian/` directory; `tools/debian/` drives reusable local/Docker/CI builds directly from the checkout.

## Key conventions

- A loaded log must contain a `t` series. The GUI assumes `t` exists, uses it as the default x-axis, and refuses to load files that do not provide it.
- Log keys are treated as underscore-delimited hierarchies. `MCLogTab.update_y_selectors()` splits every key on `_` to build the selector tree, so renaming keys changes grouping, bulk selection behavior, and how derived plots are discovered.
- Compare mode is implemented by loading a second log with `clear=False`. The code requires matching timesteps, pads series with `NaN` to align time spans, and rewrites keys under `<sanitized-filename>_...` prefixes once multiple logs are present.
- Robot-aware behavior is optional. When `mc_rbdyn` is available, the UI maps indexed joint suffixes to robot joint names for display, but saved plots convert those names back to numeric indices so persisted plots remain loadable across sessions.
- Saved UI state is user-local, not repository-local. Grid style, robot selection, saved plots, and color schemes are stored under `~/.config/mc_log_ui/`.
- `UserPlot` persistence is not plain JSON passthrough. Loading rehydrates nested `LineStyle`, `GraphLabels`, and `PlotType` values, and saving relies on custom serialization logic in `MCLogUI.saveUserPlots()`.
- If you add or change plotting behavior, keep `plot_logs.py` aligned with the GUI path. It depends on the same `UserPlot` schema and `MCLogTab.UserFigure()` reconstruction logic as the interactive application.
- Packaging scripts build directly from the checkout; edit the committed top-level `debian/` files directly.
