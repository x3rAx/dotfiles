{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      razer-battery-tray = prev.python3Packages.callPackage ../packages/razer-battery-tray {};
    })
  ];
}
