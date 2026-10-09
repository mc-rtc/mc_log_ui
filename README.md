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
