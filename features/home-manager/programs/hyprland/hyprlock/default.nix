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
    xdg.configFile."hypr/start_hyprlock.sh".source = ./start_hyprlock.sh;
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
              noise = 0.03;
            };
          }
          {
            source = "$HOME/.config/hypr/hyprland.conf";
            "$font" = "${config.hm.theme.fonts.defaultMonospace}";
            "$fgColor" = "$base0D";
            "$bgColor" = "$base03";
            "$failureColor" = "$base08";
            "$successColor" = "$base0B";
            "$checkColor" = "$base09";

            background = {
              color = "$base00";
            };

            # LAYOUT
            label = [
              {
                monitor = "";
                text = "Layout: $LAYOUT";
                color = "$fgColor";
                font_size = 25 * scale;
                font_family = "$font";
                position = "${builtins.toString (30 * scale)}, ${builtins.toString (-60 * scale)}";
                halign = "left";
                valign = "top";
                shadow_passes = 2;
                shadow_size = 5;
              }
              # TIME
              {
                monitor = "";
                text = "$TIME12";
                color = "$fgColor";
                font_size = 60 * scale;
                font_family = "$font";
                position = "${builtins.toString (-30 * scale)}, 0";
                halign = "right";
                valign = "top";
                shadow_passes = 2;
                shadow_size = 5;
              }
              # DATE
              {
                monitor = "";
                text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
                color = "$fgColor";
                font_size = 25 * scale;
                font_family = "$font";
                position = "${builtins.toString (-30 * scale)}, ${builtins.toString (-150 * scale)}";
                halign = "right";
                valign = "top";
                shadow_passes = 2;
                shadow_size = 5;
              }
            ];

            # USER AVATAR
            image = {
              monitor = "";
              path = "/var/lib/AccountsService/icons/$USER";
              size = 150 * scale;
              border_color = "$fgColor";
              border_size = 7;
              position = "0, ${builtins.toString (75 * scale)}";
              halign = "center";
              valign = "center";
              shadow_passes = 2;
              shadow_size = 5;
            };

            # INPUT FIELD
            input-field = {
              monitor = "";
              size = "${builtins.toString (250 * scale)}, ${builtins.toString (50 * scale)}";
              outline_thickness = 0;
              dots_size = 0.2 * scale;
              dots_spacing = 0.2 * scale;
              dots_center = true;
              outer_color = "$bgColor";
              inner_color = "$bgColor";
              font_color = "$fgColor";
              fade_on_empty = "false";
              placeholder_text = ''<i>󰌾 Logged in as $USER</i>'';
              hide_input = false;
              check_color = "$fgColor";
              fail_color = "$failureColor";
              fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
              capslock_color = "0xff$warning";
              position = "0, ${builtins.toString (-47 * scale)}";
              halign = "center";
              valign = "center";
              shadow_passes = 2;
              shadow_size = 5;
            };
          }
        ];
    };
  };
}
