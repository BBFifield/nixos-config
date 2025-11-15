{
  pkgs,
  config,
  lib,
  ...
}: let
  hyprShellEvents = import ../shell-events/hyprShellEventsWrapper.nix {inherit config pkgs;};
in {
  config = lib.mkIf config.hm.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once =
        [
          "uwsm app -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "uwsm app -t service -u ironbar.service -- ironbar"
          "uwsm app -t service -u swaync.service -- swaync"
          "uwsm app -t service -u walker.service -- walker --gapplication-service"
        ]
        ++ (lib.optionals (config.hm.wallpaper.daemon == "hyprpaper") [
          "uwsm app -t service -u hyprpapercycle.service -- ${(import ../../wallpaper/hyprpaper/hyprpaperCycle.nix {inherit pkgs;})}/bin/hyprpapercycle ${config.home.homeDirectory}/Pictures/wallpapers 20"
          "uwsm app -t service -u hyprpapercyclectl.service -- ${(import ../../wallpaper/hyprpaper/hyprpaperCycleCtl.nix {inherit pkgs;})}/bin/hyprpapercyclectl"
        ]);
    };
    # Currently necessary systemd unit to restart script whenever shellevents exits due to unbound variable
    systemd.user.services = {
      hyprshellevents = {
        Unit = {
          Description = "Monitor and act on Hyprland socket events";
          Requires = ["wayland-wm@Hyprland.service"];
          After = ["wayland-wm@Hyprland.service"];
          # Stop this unit when hyprland stops
          PartOf = "wayland-wm@Hyprland.service";
          StartLimitBurst = "5";
          StartLimitIntervalSec = "60";
        };
        Service = {
          Type = "simple";
          ExecStart = "${hyprShellEvents}/bin/hyprshelleventswrapper";
          Restart = "on-failure";
          RestartSec = "2";
          TimeoutStartSec = "30s";
        };
        Install = {
          WantedBy = ["wayland-wm@Hyprland.service"];
        };
      };
    };
  };
}
