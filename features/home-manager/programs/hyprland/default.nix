{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.hyprland;
  yt = pkgs.writeShellScript "yt" ''
    notify-send "Opening video" "$(wl-paste)"
    mpv "$(wl-paste)"
  '';

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";

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
    name = "Cantarell"; #"Sans";
    size = lib.mkForce 10;
  };

  settings = let
    binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
    mvfocus = binding "SUPER" "movefocus";
    ws = binding "SUPER" "workspace";
    resizeactive = binding "SUPER SHIFT" "resizeactive";
    swapactive = binding "SUPER CTRL" "swapwindow";
    mvtows = binding "SUPER SHIFT" "movetoworkspace";
    arr = [1 2 3 4 5 6 7];
  in {
    exec-once = [
      "uwsm app -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      "uwsm app -t service -u hypr-displays.service -- ${(import ./hyprDisplays.nix {inherit config pkgs;})}/bin/hypr_displays"
    ];

    monitor = lib.mapAttrsToList (name: value: "${name}, ${lib.concatStringsSep "," value.displayProps}") cfg.displayOutputs;

    env = [
      "XCURSOR_SIZE,${toString cursorTheme.size}"
      "HYPRCURSOR_SIZE,${toString cursorTheme.size}"
      "HYPRCURSOR_THEME,${cursorTheme.name}"
      "XCURSOR_THEME,${cursorTheme.name}"

      "GDK_BACKEND,wayland,x11,*"
      "GDK_SCALE,2"

      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"

      "QT_QPA_PLATFORM,wayland;xcb"
      "QT_QPA_PLATFORMTHEME,qt6ct"
    ];

    xwayland = {
      force_zero_scaling = true;
    };

    general = {
      layout = "dwindle";
      resize_on_border = true;
      border_size = 1;
    };

    misc = {
      disable_splash_rendering = true;
      force_default_wallpaper = 1;
      font_family = config.hm.theme.fonts.defaultMonospace;
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

    binds = {
      allow_workspace_cycles = true;
      workspace_center_on = 1;
    };

    dwindle = {
      pseudotile = "yes";
      preserve_split = "yes";
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_use_r = true;
    };

    windowrule = let
      f = regex: "float, class:^(${regex})$";
    in [
      (f "org.gnome.Calculator")
      (f "pavucontrol")
      (f "nm-connection-editor")
      (f "blueberry.py")
      (f "org.gnome.design.Palette")
      (f "Color Picker")
      (f "xdg-desktop-portal")
      (f "xdg-desktop-portal-gnome")
      (f "de.haeckerfelix.Fragments")
      (f "com.github.Aylur.ags")
      (f "dev.benz.walker")
      "workspace 3, class:^(org.gnome.Nautilus)$"
      "workspace 2, class:${config.hm.browsers.defaultBrowser}"
      "workspace 1, class:^(VSCodium)$"
      "opacity 0.95 override 0.9 override, class:^(Alacritty)$"
      /*
        won't match
      "workspace 3, initialTitle:^(.*Yazi.*)$, class:^(.Alacritty.*)$"
      "workspace 1, initialTitle:^(.*Alacritty.*)$, class:^(.*Alacritty.*)$, title:^(.*NVIM.*)$"
      */
    ];

    bind =
      [
        "SUPER, W, exec, [workspace 2] uwsm app -- ${config.hm.browsers.defaultBrowser}"
        "SUPER, F, exec, [workspace 3] uwsm app -- alacritty -e yazi"
        "SUPER, E, exec, uwsm app -- alacritty"
        "SUPER, C, exec, [workspace 1] uwsm app -- alacritty -e nvim"

        # youtube
        ", XF86Launch1,  exec, ${yt}"

        "ALT, Tab, focuscurrentorlast"
        "CTRL ALT, Delete, exec, loginctl terminate-user $(whoami)"
        "ALT, Q, killactive"
        "SUPER CTRL, G, togglefloating"
        "SUPER CTRL, F, fullscreen"
        "SUPER CTRL, S, togglesplit"

        (mvfocus "k" "u")
        (mvfocus "j" "d")
        (mvfocus "l" "r")
        (mvfocus "h" "l")
        (ws "left" "e-1")
        (ws "right" "e+1")
        (ws "mouse_down" "e-1")
        (ws "mouse_up" "e+1")
        (mvtows "left" "e-1")
        (mvtows "right" "e+1")
        (swapactive "k" "u")
        (swapactive "j" "d")
        (swapactive "l" "r")
        (swapactive "h" "l")
      ]
      ++ (map (i: ws (toString i) (toString i)) arr)
      ++ (map (i: mvtows (toString i) (toString i)) arr);

    binde = [
      (resizeactive "k" "0 -20")
      (resizeactive "j" "0 20")
      (resizeactive "l" "20 0")
      (resizeactive "h" "-20 0")
    ];

    bindle = [
      ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
      ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
      ",XF86KbdBrightnessUp,   exec, ${brightnessctl} -d asus::kbd_backlight set +1"
      ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight set  1-"
      ",XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
      ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
    ];

    bindl = [
      ",XF86AudioPlay,    exec, ${playerctl} play-pause"
      ",XF86AudioStop,    exec, ${playerctl} pause"
      ",XF86AudioPause,   exec, ${playerctl} pause"
      ",XF86AudioPrev,    exec, ${playerctl} previous"
      ",XF86AudioNext,    exec, ${playerctl} next"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
    ];

    bindm = [
      "SUPER, mouse:273, resizewindow"
      "SUPER, mouse:272, movewindow"
    ];

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

      dim_inactive = false;

      blur = {
        enabled = true;
        passes = 3;
        new_optimizations = "on";
        # popups = true;
        # popups_ignorealpha = 0.7;
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
        "borderangle, 1, 30, liner, loop"
        "fade, 1, 10, default"
        "workspaces, 1, 5, wind"
        "layers, 1, 5, wind, slide"
      ];
    };
  };

  extraConfig = ''
    bind = SUPER ALT, G, submap, group
    submap = group
    bind = SUPER, G, togglegroup
    bind = SUPER, left, changegroupactive,b
    bind = SUPER, right, changegroupactive, f
    ${lib.concatMapStrings (i: "bind = SUPER, ${i}, changegroupactive, ${i}\n") ["1" "2" "3" "4" "5" "6" "7"]}
    bind = SUPER, L, lockgroups, toggle
    bind = SUPER, escape, submap, reset
    submap = reset
  '';
in {
  imports = [
    ./shell
    ./hyprlock
  ];

  options.hm.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration via home-manager";
    buttonRounding = lib.mkOption {
      type = lib.types.str;
      default = "50px";
    };
    displayOutputs = mkOption {
      description = "Monitor options";
      type = with types;
        attrsOf (submodule {
          options = {
            displayProps = mkOption {
              type = with types; nullOr (listOf str);
              default = null;
              example = ["highres@highrr" "0x0" "2"];
            };
            isHDRcapable = mkOption {
              type = bool;
              default = false;
              description = ''Whether the monitor is capable of displaying HDR content.'';
            };
          };
        });
      example = {
        "HDMI-A-1" = {
          displayProps = ["highres@highrr" "0x0" "2"];
          isHDRcapable = true;
        };
      };
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        # xdg.desktopEntries = {
        #   "org.gnome.Settings" = {
        #     name = "Settings";
        #     comment = "Gnome Control Center";
        #     icon = "org.gnome.Settings";
        #     exec = "uwsm app -- env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
        #     categories = ["X-Preferences"];
        #     terminal = false;
        #   };
        # };

        home = {
          packages = with pkgs; [
            adw-gtk3
            loupe
            baobab
            wl-gammactl
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

        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-gtk
          ];
          config.common.default = [
            "hyprland"
            "gtk"
          ];
        };

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
      }
      {
        systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
      }
      {
        wayland.windowManager.hyprland = {
          enable = true;
          xwayland.enable = true;
          systemd.variables = [
            "GDK_SCALE"
          ];
          inherit settings extraConfig;
        };
      }
    ]
  );
}
