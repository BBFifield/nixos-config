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
    customModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["walker" "tools" "stats" "network" "bluetooth" "power"];
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        xdg.configFile."ironbar/style.css" = {
          text = import ./config/style.nix config;
          onChange = ''
            ${config.programs.ironbar.package}/bin/ironbar load-css "/home/$(whoami)/.config/ironbar/style.css"
          '';
        };
        xdg.configFile."ironbar/config.corn".text = import ./config/config.nix config lib;
        # xdg.configFile."ironbar/sys_info.sh".source = ./config/sys_info.sh;
        # xdg.configFile."ironbar/bluetooth.sh".source = ./config/bluetooth.sh;
        # xdg.configFile."ironbar/network.sh".source = ./config/network.sh;
      }
      {
        systemd.user.services = {
          ironbar-post-start = {
            Unit = {
              Description = "Run post-start setup for Ironbar";
              Requires = ["ironbar.service"];
              After = ["ironbar.service"];
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${pkgs.bash}/bin/bash ${(import ./postStart.nix {inherit config pkgs;})}/bin/ironbar_post_start";
              RemainAfterExit = true;
            };
            Install = {
              WantedBy = ["ironbar.service"];
            };
          };
          ironbar-stats = {
            Unit = {
              Description = "Hooks into ironbar IPC to provide live system stats";
              Requires = ["ironbar.service"];
              After = ["ironbar.service"];
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${pkgs.bash}/bin/bash ${./config/customModules/stats/stats.sh}"; #"${pkgs.bash}/bin/bash ${builtins.path {path = ./config/customModules/stats/stats.sh;}}";
              RemainAfterExit = true;
            };
            Install = {
              WantedBy = ["ironbar.service"];
            };
          };
        };
      }
      {
        hm.swaync.enable = true;

        home.packages = with pkgs; [
          playerctl
        ];

        programs.ironbar = {
          enable = true;
          systemd = false;
          config = lib.mkForce "";
          style = lib.mkForce "";
        };
      }
    ]
  );
}
