{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./emulators
    ./launchers
    ./n64ports
  ];

  config = {
    home.packages = with pkgs; [
      cartridges
    ];

    programs.lutris.enable = true;
  };
}
