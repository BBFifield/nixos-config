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
      {
        systemd.user.services.ironbar-post-start = {
          Unit = {
            Description = "Run post-start setup for Ironbar";
            Requires = ["ironbar.service"];
            After = ["ironbar.service"];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.bash}/bin/bash ${(import ./postStart.nix {inherit pkgs;}).postStart}/bin/ironbar-post-start";
            RemainAfterExit = true;
          };
          Install = {
            WantedBy = ["default.target"];
          };
        };
        # systemd.user.services.ironbar = {
        #   Unit = {
        #     Description = "Systemd service for Ironbar";
        #     Requires = ["graphical-session.target"];
        #   };
        #
        #   Service = {
        #     Type = "simple";
        #     ExecStart = lib.mkForce "${pkgs.ironbar}/bin/ironbar";
        #   };
        #
        #   Install.WantedBy = [
        #     "hyprland-session.target"
        #     "sway-session.target"
        #     "river-session.target"
        #   ];
        # };
      }
    ]
  );
}
