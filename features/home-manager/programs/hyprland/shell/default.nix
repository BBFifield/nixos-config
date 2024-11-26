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
        type = with types; nullOr (enum ["tintednix" "asztal" "hyprpanel"]);
        default = null;
        description = "Choose a customized shell.";
      };
      live = lib.mkOption {
        type = (import ../../../submodules {inherit lib;}).live;
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
      (mkIf (config.hm.hyprland.shell.name == "tintednix" && config.tintednix.targets.hyprland.enable) (
        let
          settings = {
            source = [
              "${config.home.homeDirectory}/.config/hypr/${config.tintednix.targets.hyprland.themeFilename}.conf"
              "${config.home.homeDirectory}/.config/hypr/tintednix_binding.conf"
            ];
            exec-once =
              [
                "wpaperd -d"
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                "swaync"
              ]
              ++ (lib.optionals (config.hm.gBar.enable) ["gBar bar 0"]);

            general = {
              "col.active_border" = "$base0E $base0F 45deg";
              "col.inactive_border" = "$base03 $base04 45deg";
            };

            group = {
              "col.border_active" = "$base0E $base0F 45deg";
              "col.border_inactive" = "$base03 $base04 45deg";
              "col.border_locked_active" = "$base0E $base0F 45deg";
              "col.border_locked_inactive" = "$base03 $base04 45deg";
            };

            bind = [
              "SUPER, R, exec, hyprctl dispatch closewindow '^(dev.benz.walker)$' && walker" #The first command is to ensure walker is closed if open on any other workspace
              "SUPER, N, exec, wpaperctl next"
              "SUPER, P, exec, hyprpicker --autocopy"
              "SUPER ALT, H, exec, hyprshade toggle blue-light-filter"
              "SUPER, S, exec, grim -g \"$(slurp -o -c '##$base0E')\" -t ppm - | satty --filename -"
            ];
            windowrulev2 = [
              "stayfocused, class:^(dev.benz.walker)$"
              "size ${builtins.toString (config.hm.walker.width + 30)} ${builtins.toString (config.hm.walker.height + 75)}, class:^(dev.benz.walker)$" #Needs to be add up to width and height plus total padding to fit inside window
              "opacity 0.95 override 0.90 override, class:^(dev.benz.walker)$"
            ];
          };
          mkScriptBinding = theme: mode: {
            bind = "SUPER, T, exec, tintednix ${theme} ${mode}";
          };

          schemeAttrs = config.tintednix.commonColors;

          defaultName = "${config.tintednix.defaultScheme}";

          schemeNames = lib.attrNames schemeAttrs;

          mkScriptBindingText = name: let
            nextScheme = lib.findFirst (name': name < name') null schemeNames;
            nextScheme' =
              if nextScheme != null
              then nextScheme
              else lib.elemAt schemeNames 0;
            nextMode = schemeAttrs.${nextScheme'}.variant;
          in
            lib.hm.generators.toHyprconf {
              attrs = mkScriptBinding nextScheme' nextMode;
              inherit (config.wayland.windowManager.hyprland) importantPrefixes;
            };

          scriptBindingFiles = {
            xdg = lib.mkMerge [
              (lib.foldl' (acc: item: {configFile = acc.configFile // item.configFile;}) {configFile = {};}
                (lib.map (name: {configFile."hypr/tintednix_bindings/${name}.conf".text = mkScriptBindingText name;}) schemeNames))
              {
                configFile."hypr/tintednix_binding.conf" = {
                  text = mkScriptBindingText defaultName;
                  onChange = ''
                    (
                      XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
                      if [[ -d "/tmp/hypr" || -d "$XDG_RUNTIME_DIR/hypr" ]]; then
                        for i in $(${pkgs.hyprland}/bin/hyprctl instances -j | jq ".[].instance" -r); do
                          ${pkgs.hyprland}/bin/hyprctl -i "$i" reload config-only
                        done
                      fi
                    )
                  '';
                };
              }
            ];
          };
        in
          lib.mkMerge [
            {
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
            (lib.mkIf (config.tintednix.targets.hyprland.live.enable) (lib.mkMerge [
              {
                tintednix.live.hooks = lib.mkMerge [
                  ''
                    cp -rf "$directory/hypr/tintednix_bindings/$1.conf" "$directory/hypr/tintednix_binding.conf"
                  ''
                ];
              }
              scriptBindingFiles
            ]))
          ]
      ))
    ]
  );
}
