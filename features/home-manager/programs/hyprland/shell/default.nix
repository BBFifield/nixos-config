{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  shellSubmodule = lib.types.submodule {
    options = {
      name = mkOption {
        type = with types; nullOr (enum ["tintednix"]);
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
      (mkIf (config.hm.hyprland.shell.name == "tintednix" && config.hm.tintednix.targets.hyprland.enable) (
        let
          settings = {
            source = [
              "${config.home.homeDirectory}/.config/hypr/${config.hm.tintednix.targets.hyprland.schemeFilename}.conf"
              "${config.home.homeDirectory}/.config/hypr/tintednix_binding.conf"
            ];
            exec-once = [
              # "uwsm app -t service -u wpaperd.service -- wpaperd -d"
              "uwsm app -t service -u ironbar.service -- ironbar"
              "uwsm app -t service -u swaync.service -- swaync"
              "uwsm app -t service -u walker.service -- walker --gapplication-service"
            ];

            general = {
              "col.active_border" = "$base0E $base0D 45deg";
              "col.inactive_border" = "$base03 $base04 45deg";
            };

            group = {
              "col.border_active" = "$base0E $base0F 45deg";
              "col.border_inactive" = "$base03 $base04 45deg";
              "col.border_locked_active" = "$base0E $base0F 45deg";
              "col.border_locked_inactive" = "$base03 $base04 45deg";
              groupbar = {
                font_size = 25;
                height = 15;
                text_color = "$base0D";
                "col.active" = "$base01";
                "col.inactive" = "$base02";
              };
            };

            bind = [
              "SUPER, R, exec, walker"
              "SUPER, N, exec, wpaperctl next"
              "SUPER, P, exec, ${
                if config.hm.ironbar.enable
                then "${import ../../ironbar/config/customModules/tools/updatePickedColor.nix pkgs}"
                else "hyprpicker -a"
              }"
              ''SUPER, S, exec, grim -g "$(slurp -o -c $(echo $base0D | sed 's/^....\(......\)/\1/'))" -t ppm - | satty --filename -''
            ];
            bindl = [
              "SUPER, B, exec, ${(import ../hyprsunset.nix) {inherit config pkgs;}}"
            ];

            windowrule = [
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
            ];

            experimental = let
              displays = config.hm.hyprland.displayOutputs;
              hasHDR = lib.any (display: display.isHDRcapable or false) (lib.attrValues displays);
            in {
              xx_color_management_v4 = hasHDR;
            };
          };
          mkScriptBinding = color_scheme: {
            bind = "SUPER, T, exec, tintednix --update ${color_scheme}";
          };

          schemeAttrs = config.hm.tintednix.schemeVariantAndColors;

          defaultName = "${config.hm.tintednix.defaultSchemeName}";

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
              hm.wallpaper.daemon = "wpaperd";
              hm.hyprland.hyprlock.enable = true;
              hm.walker = {
                enable = true;
              };
              hm.satty.enable = true;
              hm.ironbar = {
                enable = true;
              };
              hm.wleave.enable = true;
              home.packages = with pkgs;
                [
                  hyprpicker
                  clipse #TUI clipboard manager
                  hyprsunset #Blue light filter
                  slurp #For selecting region of the screen
                  grim #Screenshotter
                ]
                ++ lib.optionals (config.wayland.windowManager.hyprland.settings.experimental.xx_color_management_v4) [vulkan-hdr-layer-kwin6]; #For HDR https://wiki.hyprland.org/Configuring/Variables/#experimental ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk "filename"

              wayland.windowManager.hyprland = {
                inherit settings;
              };
            }
            (lib.mkIf (config.hm.tintednix.targets.hyprland.live.enable) (lib.mkMerge [
              {
                hm.tintednix.live.hooks.hotReload = lib.mkMerge [
                  ''
                    cp -rf "$config_dir/hypr/tintednix_bindings/$_theme.conf" "$config_dir/hypr/tintednix_binding.conf"
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
