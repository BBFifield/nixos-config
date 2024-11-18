{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.hyprland.hyprlock;
in {
  options.hm.hyprland.hyprlock = {
    enable = mkEnableOption "Enable Hyprlock.";
  };
  config = mkIf cfg.enable {
    xdg.configFile."hypr/start_hyprlock.sh".source = ./start_hyprlock.sh; # This ensures the script is available to ironbar while its config is outside of the store;
    programs.hyprlock = {
      enable = true;

      settings = let
        scale =
          {
            "1" = 2; # "1" is true
            "" = 1; # "" is false
          }
          .${builtins.toString config.hm.hidpi.enable};
      in
        mkMerge [
          {
            # GENERAL
            general = {
              disable_loading_bar = true;
              hide_cursor = false;
            };

            # BACKGROUND
            background = {
              monitor = "";
              path = "/tmp/hyprlock_screenshot1.png"; #"$HOME/.config/background";
              blur_passes = 2;
            };
          }
          {
            source = "$HOME/.config/hypr/hyprland.conf";
            "$accent" = "0xff$base14";
            "$accentAlpha" = "0xff$base15";
            "$textVar" = "0xff$base09";
            "$font" = "${config.hm.theme.fonts.defaultMonospace}";

            background = {
              color = "0xff$base00";
            };

            # LAYOUT
            label = [
              {
                monitor = "";
                fg = "Layout: $LAYOUT";
                color = "$fgVar";
                font_size = 25 * scale;
                font_family = "$font";
                position = "${builtins.toString (30 * scale)}, ${builtins.toString (-60 * scale)}";
                halign = "left";
                valign = "top";
              }
              # TIME
              {
                monitor = "";
                fg = "$TIME";
                color = "$fgVar";
                font_size = 90 * scale;
                font_family = "$font";
                position = "${builtins.toString (-30 * scale)}, 0";
                halign = "right";
                valign = "top";
              }
              # DATE
              {
                monitor = "";
                fg = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
                color = "$fgVar";
                font_size = 25 * scale;
                font_family = "$font";
                position = "${builtins.toString (-30 * scale)}, ${builtins.toString (-150 * scale)}";
                halign = "right";
                valign = "top";
              }
            ];

            # USER AVATAR
            image = {
              monitor = "";
              path = "/var/lib/AccountsService/icons/$USER";
              size = 150 * scale;
              border_color = "$accent";
              position = "0, ${builtins.toString (75 * scale)}";
              halign = "center";
              valign = "center";
            };

            # INPUT FIELD
            input-field = {
              monitor = "";
              size = "${builtins.toString (250 * scale)}, ${builtins.toString (50 * scale)}";
              outline_thickness = 4;
              dots_size = 0.2 * scale;
              dots_spacing = 0.2 * scale;
              dots_center = true;
              outer_color = "$accent";
              inner_color = "0xff$fg_field";
              font_color = "$fgVar";
              fade_on_empty = "false";
              placeholder_fg = ''<span foreground="##$fg"><i>󰌾 Logged in as </i><span foreground="##$active_accent1">$USER</span></span>'';
              hide_input = false;
              check_color = "$accent";
              fail_color = "0xff$failure";
              fail_fg = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
              capslock_color = "0xff$warning";
              position = "0, ${builtins.toString (-47 * scale)}";
              halign = "center";
              valign = "center";
            };
          }
        ];
    };
  };
}
