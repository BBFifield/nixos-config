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
        home.packages = [(import ./cycleCtl.nix {inherit pkgs;})];
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
