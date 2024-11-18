{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.ironbar;
in {
  options.hm.ironbar = {
    enable = lib.mkEnableOption "Enable ironbar statusbar.";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          playerctl
          swaynotificationcenter
        ];

        programs.ironbar = {
          enable = true;
          systemd = true;
          config = "";
          style = "";
        };
      }
    ]
  );
}
