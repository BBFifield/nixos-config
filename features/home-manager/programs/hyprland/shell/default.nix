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
              "${config.home.homeDirectory}/.config/hypr/${config.tintednix.targets.hyprland.schemeFilename}.conf"
              "${config.home.homeDirectory}/.config/hypr/tintednix_binding.conf"
            ];
            exec-once =
              [
                "uwsm app -- wpaperd -d"
                "uwsm app -- swaync"
                "uwsm app -t service -u ironbar.service -- ironbar"
                "uwsm app -t service -u walker.service -- walker --gapplication-service"
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
              "SUPER, R, exec, walker"
              "SUPER, N, exec, wpaperctl next"
              "SUPER, P, exec, hyprpicker --autocopy"
              "SUPER ALT, H, exec, uwsm app -t service -u hyprsunset.service -- hyprsunset -t 3000"
              ''SUPER, S, exec, grim -g "$(slurp -o -c $(echo $base0D | sed 's/^....\(......\)/\1/'))" -t ppm - | satty --filename -''
            ];
            windowrulev2 = [
              #"stayfocused, class:^(dev.benz.walker)$"
              "opacity 0.90 override 0.85 override, class:^(dev.benz.walker)$"
            ];
          };
          mkScriptBinding = color_scheme: {
            bind = "SUPER, T, exec, tintednix update ${color_scheme}";
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
          in
            lib.hm.generators.toHyprconf {
              attrs = mkScriptBinding nextScheme';
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
                hyprsunset #Blue light filter
                slurp #For selecting region of the screen
                grim #Screenshotter
              ];

              wayland.windowManager.hyprland = {
                inherit settings;
              };
            }
            (lib.mkIf (config.tintednix.targets.hyprland.live.enable) (lib.mkMerge [
              {
                tintednix.live.hooks.hotReload = lib.mkMerge [
                  ''
                    cp -rf "$directory/hypr/tintednix_bindings/$arg2.conf" "$directory/hypr/tintednix_binding.conf"
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
