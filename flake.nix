{
  description = "mc_log_ui: python utility to display mc_rtc logs";

  inputs.mc-rtc-nix.url = "github:mc-rtc/nixpkgs";

  outputs =
    inputs:
    inputs.mc-rtc-nix.lib.mkFlakoboros inputs (
      { ... }:
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
            }:
            buildPythonPackage {
              pname = "mc_log_ui";
              version = "1.0.0";
              pyproject = true;

              src = ./.;

              build-system = [ setuptools ];
              propagatedBuildInputs = [
                pyqt5
                numpy
                matplotlib
              ];

              postFixup = ''
                wrapProgram $out/bin/mc_log_ui \
                  --set PYTHONPATH "$out/${python.sitePackages}:$PYTHONPATH" \
                  --set QT_PLUGIN_PATH "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}"
              '';
            };
        };
      }
    );
}
