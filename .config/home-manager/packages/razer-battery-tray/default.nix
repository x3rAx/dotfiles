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
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "HoroTW";
    repo = "RazerBatteryTray";
    rev = "268ae04";
    sha256 = "sha256-Mrg6kW2et4wCQ8Z+f9Tfr+qOmLb8RLvzBTN5BB1Ah4s=";
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

  patches = [
    ./icons-dir.patch
  ];

  dontConfigure = true;

  buildPhase = ''
    cat ./razer_battery_tray.py
    python ./generate_new_bat_icons.py
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/razerBatteryTray/
    cp ./razer_battery_tray.py $out/bin/razer_battery_tray
    cp -R ./icons $out/share/razerBatteryTray/
  '';
}


