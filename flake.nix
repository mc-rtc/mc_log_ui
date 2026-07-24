{
  description = "mc_log_ui: python utility to display mc_rtc logs";

  # inputs.mc-rtc-nix.url = "github:mc-rtc/nixpkgs";
  inputs.mc-rtc-nix.url = "path:/home/arnaud/devel/mc-rtc-nix/nixpkgs";

  outputs =
    inputs:
    inputs.mc-rtc-nix.lib.mkFlakoboros inputs (
      { lib, ... }:
      {
        pyPackages = {
          mc-log-ui =
            {
              buildPythonPackage,
              python,
              setuptools,
              pyqt5,
              numpy,
              matplotlib,
              qt5,
              mc-rtc,
              with-mc-rtc ? true,
            }:
            buildPythonPackage {
              pname = "mc_log_ui";
              version = "1.0.0";
              pyproject = true;
              # without this it tries to use cmake when including mc-rtc, why?
              dontConfigure = true;

              src = ./.;

              build-system = [ setuptools ];
              propagatedBuildInputs = [
                pyqt5
                numpy
                matplotlib
              ]
              ++ (lib.optional with-mc-rtc mc-rtc);

              postFixup = ''
                wrapProgram $out/bin/mc_log_ui \
                  --set PYTHONPATH "$out/${python.sitePackages}:$PYTHONPATH" \
                  --set QT_PLUGIN_PATH "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}"
                wrapProgram $out/bin/plot_logs \
                  --set PYTHONPATH "$out/${python.sitePackages}:$PYTHONPATH" \
                  --set QT_PLUGIN_PATH "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}"
              '';
            };
        };
      }
    );
}
