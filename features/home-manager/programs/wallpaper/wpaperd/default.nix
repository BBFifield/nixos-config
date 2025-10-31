{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf (config.hm.wallpaper.daemon == "wpaperd") {
    xdg.configFile."wpaperd/chosen-wallpaper.toml".source = (pkgs.formats.toml {}).generate "chosen-wallpaper.toml" {
      default = {
        mode = "center";
        transition = {
          doorway = {};
        };
      };
      any = {
        path = "${config.home.homeDirectory}/.cache/wpaperd/wallpaper/current";
      };
    };

    services.wpaperd = {
      enable = true;
      settings = lib.mkMerge [
        (lib.mkIf (config.hm.wallpaper.cycle) {
          default = {
            duration = "30m";
            mode = "center";
            sorting = "random";
            transition = {
              doorway = {};
            };
          };
          any = {
            path = "${config.home.homeDirectory}/Pictures/wallpapers";
          };
        })
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
