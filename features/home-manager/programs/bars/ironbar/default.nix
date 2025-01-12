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
    enabledModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["bluetooth" "stats" "powerMenu"];
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        xdg.configFile."ironbar/style.css".text = (import ./config/style_ironbar.nix {inherit config;}).style; #''${compiledSassFile}/.config/ironbar/style.css'';
        xdg.configFile."ironbar/config.corn".text = (import ./config/config.nix {inherit config;}).ironbarConfig;
        xdg.configFile."ironbar/sys_info.sh".source = ./config/sys_info.sh;
        # xdg.configFile."ironbar/stats.sh".source = ./config/stats.sh;
        xdg.configFile."ironbar/bluetooth.sh".source = ./config/bluetooth.sh;
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
              ExecStart = "${pkgs.bash}/bin/bash ${(import ./postStart.nix {inherit config pkgs;}).postStart}/bin/ironbar_post_start";
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
              ExecStart = "${pkgs.bash}/bin/bash ${builtins.path {path = ./config/stats.sh;}}";
              RemainAfterExit = true;
            };
            Install = {
              WantedBy = ["ironbar.service"];
            };
          };
        };
      }
      {
        home.packages = with pkgs; [
          playerctl
          swaynotificationcenter
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
