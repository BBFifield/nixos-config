{
  config,
  lib,
  pkgs,
  ...
}: let
  theme = {
    name = config.hm.theme.gtkTheme.name;
  };
  cursorTheme = {
    name = config.hm.theme.cursorTheme.name;
    size = config.hm.theme.cursorTheme.size;
    package = config.hm.theme.cursorTheme.package;
  };
  iconTheme = {
    name = config.hm.theme.iconTheme;
  };
  font = {
    name = config.hm.theme.fonts.defaultMonospace; #"Sans";
    size = lib.mkForce 16;
  };
in {
  options.hm.hyprland = {
    buttonRounding = lib.mkOption {
      type = lib.types.str;
      default = "50px";
    };
  };

  config = lib.mkIf config.hm.hyprland.enable {
    home = {
      packages = with pkgs; [
        adw-gtk3
      ];
      sessionVariables = {
        XCURSOR_THEME = cursorTheme.name;
        XCURSOR_SIZE = "${toString cursorTheme.size}";
      };
      pointerCursor = cursorTheme // {gtk.enable = true;};
    };
    gtk = {
      enable = true;
      inherit theme cursorTheme iconTheme font;
    };

    wayland.windowManager.hyprland = {
      systemd.variables = [
        "GDK_SCALE"
      ];
      settings = {
        decoration = {
          rounding = 10;
          shadow = {
            color = "rgba(000000AA)";
            color_inactive = "rgba(00000066)";
            enabled = true;
            range = 60;
            render_power = 2;
            offset = "14 25";
            scale = 0.95;
          };
          # Change transparency of focused and unfocused windows
          active_opacity = 0.95;
          inactive_opacity = 0.9;

          dim_inactive = true;
          dim_strength = 0.3;

          blur = {
            enabled = true;
            passes = 3;
            new_optimizations = "on";
            popups = true;
            # popups_ignorealpha = 0.7;
          };
        };

        general = {
          "col.active_border" = "$base02 $base01 30deg";
          "col.inactive_border" = "$base02 $base01 30deg";
        };

        group = {
          "col.border_active" = "$base0E $base0F 45deg";
          "col.border_inactive" = "$base03 $base04 45deg";
          "col.border_locked_active" = "$base0E $base0F 45deg";
          "col.border_locked_inactive" = "$base03 $base04 45deg";
          drag_into_group = 2;
          groupbar = {
            "col.active" = "$base0D";
            "col.inactive" = "$base01";
            "col.locked_active" = "$base08";
            "col.locked_inactive" = "$base01";
            text_color = "$base01";
            text_color_inactive = "$base0D";
            font_size = 16;
            height = 22;
            indicator_height = 0;
            gradients = true;
            gradient_rounding = 22;
            round_only_edges = false;
            gradient_round_only_edges = true;
            keep_upper_gap = false;
            gaps_out = 0;
            gaps_in = 0;
          };
        };

        animations = {
          enabled = "yes";
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 5, liner, once"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
            "layers, 1, 5, wind, slide"
          ];
        };

        windowrule = let
          f = regex: "float, class:^(${regex})$";
        in [
          (f "org.gnome.Calculator")
          (f "nm-connection-editor")
          (f "org.gnome.design.Palette")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
          (f "dev.benz.walker")
          (f "com.network.manager")

          "workspace 0, initialClass:^(Slack)$"
          "workspace 0, initialClass:^(discord)$"
          "workspace 9, initialClass:^(steam)$"
          "workspace 8, initialClass:^(mpv)$"
          "workspace 7, initialClass:^(com.saivert.pwvucontrol)$"
          "workspace 7, initialClass:^(tauonmb)$"
          "workspace 7, initialClass:^(ca.edestcroix.Recordbox)$"
          "workspace 7, initialClass:^(org.gnome.Music)$"
          "workspace 6, initialClass:^(org.gnome.Loupe)$"
          "workspace 6, initialClass:^(gimp)$"
          "workspace 3, initialClass:^(de.haeckerfelix.Fragments)$"
          "workspace 3, class:^(org.gnome.Nautilus)$"
          "workspace 3, initialTitle:^(Yazi)$"
          "workspace 2, class:^(VSCodium)$"
          "workspace 2, initialTitle:^(NVIM)$"
          "workspace 1, class:^(.*${config.hm.browsers.defaultBrowser}.*)$"

          "opacity 0.95 override 0.90 override, initialTitle:^(NVIM)$"
          "opacity 1.0 override 0.95 override, class:^(Alacritty)$"
          "opacity 1.0 override 0.95 override, class:^(dev.benz.walker)$"
        ];
        layerrule = [
          "animation fade, wleave"
          "blur, wleave"
          "blur, ironbar"
          "blur, walker"
          "blurpopups, ironbar"
          "ignorealpha 0.8, ironbar"
          "ignorealpha 0.8, walker"
          "blur, swaync-control-center"
          "ignorealpha 0.8, swaync-control-center"
          "animation slide top, swaync-control-center"
          "animation popin, hyprpaper"
        ];

        xwayland = {
          force_zero_scaling = true;
        };

        general = {
          border_size = 1;
          gaps_in = 3;
          gaps_out = "0, 10, 10, 10";
        };

        misc = {
          disable_splash_rendering = true;
          force_default_wallpaper = 1;
          font_family = config.hm.theme.fonts.defaultMonospace;
        };

        env = [
          "XCURSOR_SIZE,${toString cursorTheme.size}"
          "HYPRCURSOR_SIZE,${toString cursorTheme.size}"
          "HYPRCURSOR_THEME,${cursorTheme.name}"
          "XCURSOR_THEME,${cursorTheme.name}"

          "GDK_SCALE,2"

          "QT_QPA_PLATFORMTHEME,qt6ct"
        ];
      };
    };
  };
}
