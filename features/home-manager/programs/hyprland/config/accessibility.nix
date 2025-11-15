{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.hm.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      misc = {
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        focus_on_activate = true;
        allow_session_lock_restore = true;
      };

      cursor = {
        inactive_timeout = 5;
      };

      input = {
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          drag_lock = true;
        };
        sensitivity = 0;
        float_switch_override_focus = 2;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      general = {
        layout = "dwindle";
        resize_on_border = true;
      };
    };
  };
}
