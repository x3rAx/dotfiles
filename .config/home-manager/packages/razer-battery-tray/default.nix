{ lib, pkgs, stdenv
, fetchFromGitHub
, buildPythonPackage
, python3
, dejavu_fonts
, libappindicator
, python3Packages
, wrapGAppsHook
, gobject-introspection
}:

buildPythonPackage {
  format = "other";

  pname = "RazerBatteryTray";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "HoroTW";
    repo = "RazerBatteryTray";
    rev = "v1.0";
    sha256 = "sha256-SBDzJi5KOi15PWJR1gdSp47MK1ihvgXjIxxPKBFKHvw=";
  };

  # Programs and libraries used at *build*-time on the build host
  nativeBuildInputs = [
    dejavu_fonts
    gobject-introspection
  ];

  # Programs and libraries used by the new derivation at *run*-time on the target host
  buildInputs = [
    libappindicator
    (python3.withPackages (pythonPackages: with python3Packages; [
      openrazer
      pillow
      pystray
    ]))
    wrapGAppsHook
    gobject-introspection
  ];

  propagatedBuildInputs = [
  ];

  buildPhase = ''
    python ./src/generate_new_bat_icons.py
  '';

  installPhase = ''
    mkdir -p $out/bin

    # Modules
    cp ./src/logger.py $out/bin/
    cp ./src/argument_parser.py $out/bin/
    cp ./src/rbt_manager.py $out/bin/

    # Binary
    cp ./src/razer_battery_tray.py $out/bin/razer_battery_tray

    # Icons
    cp -R ./icons $out/
  '';
}


