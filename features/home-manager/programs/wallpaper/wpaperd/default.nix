{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  configTemplate = sortMethod: {
    default = {
      duration = "30m";
      mode = "center";
      sorting = sortMethod;
      transition = {
        doorway = {};
      };
      exec = import ./onChange.nix {inherit config pkgs;};
    };
    any = {
      path = "${config.home.homeDirectory}/Pictures/wallpapers";
    };
  };
in {
  config = mkIf (config.hm.wallpaper.daemon == "wpaperd") {
    xdg.configFile = {
      "wpaperd/configs/random.toml".source = (pkgs.formats.toml {}).generate "random.toml" (configTemplate "random");
      "wpaperd/configs/ordered.toml".source = (pkgs.formats.toml {}).generate "ordered.toml" (configTemplate "ascending");
      "wpaperd/configs/wpaperd.state".text = ''${config.hm.wallpaper.defaultSortMethod}'';
    };

    services.wpaperd = {
      enable = true;
      settings = lib.mkMerge [
        (lib.mkIf (config.hm.wallpaper.cycle) (configTemplate "${config.hm.wallpaper.defaultSortMethod}"))
        (lib.mkIf (!config.hm.wallpaper.cycle) {
          default = {
            mode = "center";
            transition = {
              doorway = {};
            };
          };
          any = {
            path = ../../../default-wallpaper/background-nixos.png;
          };
        })
      ];
    };
  };
}
