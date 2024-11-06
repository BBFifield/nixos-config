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
        type = with types; nullOr (enum ["vanilla" "asztal" "hyprpanel"]);
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

  settings = {
    source =
      [
        "${config.home.homeDirectory}/.config/hypr/hyprland_colorscheme.conf"
      ]
      ++ (lib.optionals (config.hm.hyprland.shell.hot-reload.enable) ["${config.home.homeDirectory}/.config/hypr/colorscheme_settings.conf"]);

    exec-once =
      [
        "wpaperd -d"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ]
      ++ (lib.optionals (config.hm.gBar.enable) ["gBar bar 0"]);

    general = {
      "col.active_border" = "0xff$active_accent1 0xff$active_accent2 45deg";
      "col.inactive_border" = "0xcc$inactive_accent1 0xcc$inactive_accent2 45deg";
    };

    group = {
      "col.border_active" = "0xff$active_accent1 0xff$active_accent2 45deg";
      "col.border_inactive" = "0xcc$inactive_accent1 0xcc$inactive_accent2 45deg";
      "col.border_locked_active" = "0xff$active_accent1 0xff$active_accent2 45deg";
      "col.border_locked_inactive" = "0xcc$inactive_accent1 0xcc$inactive_accent2 45deg";
    };

    bind = [
      "SUPER, R, exec, walker"
      "SUPER, N, exec, wpaperctl next"
      "SUPER, P, exec, hyprpicker --autocopy"
      "SUPER ALT, H, exec, hyprshade toggle blue-light-filter"
      "SUPER, S, exec, grim -g \"$(slurp -o -c '##$active_accent1ff')\" -t ppm - | satty --filename -"
    ];
  };

  colorschemeSettings = theme: mode: {
    bind = "SUPER, T, exec, switch-colorscheme ${theme} ${mode}";
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
      (mkIf (cfg.name == "vanilla") (
        let
          attrset = import ../../../lookAndFeel/colorschemeInfo.nix;
          defaultTheme = config.hm.theme.colorscheme.name;
          defaultVariant = config.hm.theme.colorscheme.variant;
          defaultName = "${defaultTheme}_${defaultVariant}";

          themeNames = lib.attrNames attrset;
          getVariantNames = theme: lib.attrNames attrset.${theme}.variants;
          sortedNames = lib.sort (a: b: a < b) (lib.concatMap (theme: (lib.map (variant: "${theme}_${variant}") (getVariantNames theme))) themeNames);

          mkHyprColor = name: value: {
            name = "\$${name}";
            value = "${value}";
          };

          unpacked = lib.listToAttrs (lib.concatMap (theme:
            lib.map (variant: {
              name = "${theme}_${variant}";
              value = let
                cognates = attrset.${theme}.cognates variant;
              in {
                inherit cognates;
                colorAttrs = lib.listToAttrs (lib.map (cognateName: mkHyprColor cognateName cognates.${cognateName}) (lib.attrNames cognates));
              };
            }) (getVariantNames theme))
          themeNames);

          mkColorFile = name: value: {
            xdg.configFile."hypr/hyprland_colorschemes/${name}.conf".text = lib.hm.generators.toHyprconf {
              attrs = value.colorAttrs;
            };
          };

          mkSettingsText = name: let
            nextColorscheme = lib.findFirst (name': name < name') null sortedNames;
            nextColorscheme' =
              if nextColorscheme != null
              then nextColorscheme
              else lib.elemAt sortedNames 0;
            splittedName = lib.splitString "_" nextColorscheme';
            nextName = lib.elemAt splittedName 0;
            nextVariant = lib.elemAt splittedName 1;
            nextMode = attrset.${nextName}.variants.${nextVariant}.mode;
          in
            lib.hm.generators.toHyprconf {
              attrs = colorschemeSettings nextColorscheme' nextMode;
              inherit (config.wayland.windowManager.hyprland) importantPrefixes;
            };

          colorFiles =
            lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} (lib.attrValues (lib.mapAttrs (name: value: mkColorFile name value) unpacked));

          settingsFiles = mkMerge [
            (lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} (lib.attrValues (lib.mapAttrs (name: value: {xdg.configFile."hypr/colorscheme_settings/${name}.conf".text = mkSettingsText name;}) unpacked)))
            {
              xdg.configFile."hypr/colorscheme_settings.conf" = {
                text = mkSettingsText defaultName;
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
        in
          mkMerge [
            {
              hm.wpaperd.enable = true;
              hm.hyprland.hyprlock.enable = true;
              hm.walker.enable = true;
              hm.satty.enable = true;
              hm.ironbar = {
                enable = true;
                hot-reload.enable = true;
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

              xdg.configFile."hypr/hyprland_colorscheme.conf".text = lib.hm.generators.toHyprconf {
                attrs = (lib.filterAttrs (n: v: defaultName == n) unpacked).${defaultName}.colorAttrs;
              };
            }
            (lib.mkIf (cfg.hot-reload.enable) (mkMerge [
              {
                hm.theme.hot-reload.scriptParts = lib.mkMerge [
                  (lib.mkOrder 10 ''
                    rm "$directory/hypr/colorscheme_settings.conf" "$directory/hypr/hyprland_colorscheme.conf"
                    cp -rf "$directory/hypr/hyprland_colorschemes/$1.conf" "$directory/hypr/hyprland_colorscheme.conf"
                    cp -rf "$directory/hypr/colorscheme_settings/$1.conf" "$directory/hypr/colorscheme_settings.conf"
                  '')

                  (lib.mkOrder 40 ''
                    hyprctl reload
                  '')
                ];

                /*
                home.activation.hypr = lib.hm.dag.entryAfter ["writeBoundary"] ''
                 log_file="${config.home.homeDirectory}/hyprland_activation.log"
                echo "Checking for Hyprland process..." >> $log_file
                 echo $(pgrep -i hyprland) >> $log_file 2>&1

                   echo $(${pkgs.hyprland}/bin/hyprctl -i 0 reload) >> $log_file 2>&1

                   echo "Notice: Ignoring hyprland activation script. Hyprland is not running." >> $log_file                '';
                */
              }
              colorFiles
              settingsFiles
            ]))
          ]
      ))
    ]
  );
}
