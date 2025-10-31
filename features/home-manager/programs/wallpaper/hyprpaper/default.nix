{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf (config.hm.wallpaper.daemon == "hyprpaper") (
    lib.mkMerge [
      (mkIf (config.hm.wallpaper.cycle) {
        home.packages = [(import ./hyprpaperCycleCtl.nix {inherit pkgs;})];
      })

      {
        services.hyprpaper = {
          enable = true;

          settings = {
            ipc = "on";
            splash = false;
          };
        };
      }
    ]
  );
}
