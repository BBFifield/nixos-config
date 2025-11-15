{lib, ...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "sleep 1s && hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1200;
          on-timeout = "sleep 1s && hyprctl dispatch dpms off";
          on-resume = "sleep 1s && hyprctl dispatch dpms on";
        }
      ];
    };
  };
  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
