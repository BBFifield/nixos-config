{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./hyprpaper
    ./wpaperd
  ];

  options.hm.wallpaper = {
    enable = lib.mkEnableOption "Enable wallpaper configuration via home-manager";
    daemon = lib.mkOption {
      type = lib.types.enum ["hyprpaper" "wpaperd"];
      default = "hyprpaper";
    };
    cycle = lib.mkEnableOption "Enable toggle script for cycling the wallpaper";
    defaultSortMethod = lib.mkOption {
      type = lib.types.enum ["random" "ordered"];
      default = "random";
    };
  };

  config = {
    hm.wallpaper = {
      enable = true;
      cycle = true;
    };
  };
}
