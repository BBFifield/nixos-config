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
          config = lib.mkForce "";
          style = lib.mkForce "";
        };
      }
      {
        xdg.configFile."ironbar/style.css".source = ./config/style_ironbar.css; #''${compiledSassFile}/.config/ironbar/style.css'';
        xdg.configFile."ironbar/config.corn".source = ./config/config.corn;
        xdg.configFile."ironbar/sys_info.sh".source = ./config/sys_info.sh;
        xdg.configFile."ironbar/iron_bluetooth.sh".source = ./config/iron_bluetooth.sh;
      }
    ]
  );
}
