{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./emulators
    ./launchers
    # ./sm64ex
  ];

  config = {
    home.packages = with pkgs; [
      cartridges
      shipwright
    ];

    programs.lutris.enable = true;
  };
}
