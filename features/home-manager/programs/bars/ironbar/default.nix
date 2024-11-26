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
        xdg.configFile."ironbar/style.css" = {
          source = ./config/style_ironbar.css; #''${compiledSassFile}/.config/ironbar/style.css'';
          onChange = ''
            (
              log_file="${config.home.homeDirectory}/ironbar-reload.log"
              echo "Checking for ironbar-ipc..." >> $log_file
              XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
              if [[ -S "$XDG_RUNTIME_DIR/ironbar-ipc.sock" ]]; then
                echo "ipc file exists" >> $log_file 2>&1
                ${pkgs.ironbar}/bin/ironbar load-css "${config.home.homeDirectory}/.config/ironbar/style.css"
              else
                echo "ipc file doesn't exist" >> $log_file
              fi
            )
          '';
        };
        xdg.configFile."ironbar/config.corn".source = ./config/config.corn;
        xdg.configFile."ironbar/sys_info.sh".source = ./config/sys_info.sh;
      }
    ]
  );
}
