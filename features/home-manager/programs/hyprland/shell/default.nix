{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.hyprland.shell;
  shellSubmodule = lib.types.submodule {
    options = {
      name = mkOption {
        type = with types; nullOr (enum ["snow-globe" "asztal" "hyprpanel"]);
        default = null;
        description = "Choose a customized shell.";
      };
      hot-reload = lib.mkOption {
        type = (import ../../../submodules {inherit lib;}).hot-reload;
      };
      baseConfig = mkOption {
        type = types.attrs;
        default = {};
      };
    };
  };
in {
  options.hm.hyprland = {
    shell = mkOption {
      type = shellSubmodule;
      description = "Choose a customized shell.";
    };
  };

  config = mkIf config.hm.hyprland.enable (
    mkMerge [
      (mkIf (config.hm.hyprland.shell.name == "hyprpanel") {
        home = {
          packages = with pkgs; [
            hyprpanel
          ];
        };

        wayland.windowManager.hyprland = {
          settings = {
            exec-once = [
              "${pkgs.hyprpanel}/bin/hyprpanel"
            ];
          };
        };
      })
      (mkIf (config.hm.hyprland.shell.name == "asztal") {
        home = {
          packages = with pkgs; [
            asztal
          ];
        };

        wayland.windowManager.hyprland = {
          settings = {
            exec-once = [
              "asztal -b hypr"
            ];

            bind = let
              e = "exec, asztal -b hypr";
            in [
              "CTRL SHIFT, R,  ${e} quit; asztal -b hypr"
              "SUPER, R,       ${e} -t launcher"
              "SUPER, Tab,     ${e} -t overview"
              ",XF86PowerOff,  ${e} -r 'powermenu.shutdown()'"
              ",XF86Launch4,   ${e} -r 'recorder.start()'"
              ",Print,         ${e} -r 'recorder.screenshot()'"
              "SHIFT,Print,    ${e} -r 'recorder.screenshot(true)'"
            ];
          };
        };
      })
      (mkIf (config.hm.hyprland.shell.name == "snow-globe") (
        let
          settings = {
            exec-once =
              [
                "wpaperd -d"
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                "swaync"
              ]
              ++ (lib.optionals (config.hm.gBar.enable) ["gBar bar 0"]);

            general = {
              "col.active_border" = "0xff$base0E 0xff$base0F 45deg";
              "col.inactive_border" = "0xcc$base03 0xcc$base04 45deg";
            };

            group = {
              "col.border_active" = "0xff$base0E 0xff$base0F 45deg";
              "col.border_inactive" = "0xcc$base03 0xcc$base04 45deg";
              "col.border_locked_active" = "0xff$base0E 0xff$base0F 45deg";
              "col.border_locked_inactive" = "0xcc$base03 0xcc$base04 45deg";
            };

            bind = [
              "SUPER, R, exec, hyprctl dispatch closewindow '^(dev.benz.walker)$' && walker" #The first command is to ensure walker is closed if open on any other workspace
              "SUPER, N, exec, wpaperctl next"
              "SUPER, P, exec, hyprpicker --autocopy"
              "SUPER ALT, H, exec, hyprshade toggle blue-light-filter"
              "SUPER, S, exec, grim -g \"$(slurp -o -c '##$base0Eff')\" -t ppm - | satty --filename -"
            ];
            windowrulev2 = [
              "stayfocused, class:^(dev.benz.walker)$"
              "size ${builtins.toString (config.snow-globe.targets.walker.width + 30)} ${builtins.toString (config.snow-globe.targets.walker.height + 75)}, class:^(dev.benz.walker)$" #Needs to be add up to width and height plus total padding to fit inside window
              "opacity 0.95 override 0.90 override, class:^(dev.benz.walker)$"
            ];
          };
        in {
          hm.wpaperd.enable = true;
          hm.hyprland.hyprlock.enable = true;
          hm.walker = {
            enable = true;
          };
          hm.satty.enable = true;
          hm.ironbar = {
            enable = true;
          };
          home.packages = with pkgs; [
            hyprpicker
            clipse #TUI clipboard manager
            hyprshade #Screenshader utility
            slurp #For selecting region of the screen
            grim #Screenshotter
          ];

          wayland.windowManager.hyprland = {
            inherit settings;
          };
        }
      ))
    ]
  );
}
