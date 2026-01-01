{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      cemu
    ];

    xdg.configFile = {
      "Cemu/settings.xml" = {
        source = ./config/settings.xml;
        force = true;
      };
      "Cemu/controllerProfiles" = {
        source = ./config/controllerProfiles;
        recursive = true;
      };
    };
  };
}
