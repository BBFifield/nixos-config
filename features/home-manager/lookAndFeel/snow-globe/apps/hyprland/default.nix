{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.snow-globe.targets.hyprland;
in {
  options.snow-globe.targets.hyprland = {
    enable = lib.mkEnableOption "Enable target, Walker launcher.";

    hot-reload = lib.mkOption {
      type = (import ../../../../submodules {inherit lib;}).hot-reload;
    };
  };

  config = let
    settings = {
      source = [
        "${config.home.homeDirectory}/.config/hypr/hyprland_colorscheme.conf"
        "${config.home.homeDirectory}/.config/hypr/colorscheme_settings.conf"
      ];
    };

    colorschemeSettings = theme: mode: {
      bind = "SUPER, T, exec, switch-colorscheme ${theme} ${mode}";
    };

    schemeAttrs = config.snow-globe.commonColors;

    defaultTheme = config.hm.theme.colorscheme.name;
    defaultVariant = config.hm.theme.colorscheme.variant;
    defaultName = "${defaultTheme}-${defaultVariant}";

    schemeNames = lib.attrNames schemeAttrs;

    unpacked = lib.listToAttrs (lib.map (schemeName: {
        name = schemeName;
        value = let
          colorAttrs = schemeAttrs."${schemeName}".colors;
        in {
          inherit colorAttrs;
          hyprColorAttrs = lib.listToAttrs (lib.map (colorName: {
            name = "\$${colorName}";
            value = "${colorAttrs.${colorName}}";
          }) (lib.attrNames colorAttrs));
        };
      })
      schemeNames);

    mkColorFile = name: value: {
      configFile."hypr/hyprland_colorschemes/${name}.conf".text = lib.hm.generators.toHyprconf {
        attrs = value.hyprColorAttrs;
      };
    };

    mkSettingsText = name: let
      nextScheme = lib.findFirst (name': name < name') null schemeNames;
      nextScheme' =
        if nextScheme != null
        then nextScheme
        else lib.elemAt schemeNames 0;
      nextMode = schemeAttrs.${nextScheme'}.variant;
    in
      lib.hm.generators.toHyprconf {
        attrs = colorschemeSettings nextScheme' nextMode;
        inherit (config.wayland.windowManager.hyprland) importantPrefixes;
      };

    colorFiles = {
      xdg = lib.mkMerge [
        (lib.foldl' (acc: item: {configFile = acc.configFile // item.configFile;}) {configFile = {};}
          (lib.attrValues (lib.mapAttrs (name: value: mkColorFile name value) unpacked)))
      ];
    };

    settingsFiles = {
      xdg = lib.mkMerge [
        (lib.foldl' (acc: item: {configFile = acc.configFile // item.configFile;}) {configFile = {};}
          (lib.attrValues (lib.mapAttrs (name: value: {configFile."hypr/colorscheme_settings/${name}.conf".text = mkSettingsText name;}) unpacked)))
        {
          configFile."hypr/colorscheme_settings.conf" = {
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
    };
  in (lib.mkIf (cfg.enable) (
    lib.mkMerge [
      {
        wayland.windowManager.hyprland = {
          inherit settings;
        };

        xdg.configFile."hypr/hyprland_colorscheme.conf".text = lib.hm.generators.toHyprconf {
          attrs = (lib.filterAttrs (n: v: defaultName == n) unpacked).${defaultName}.hyprColorAttrs;
        };
      }
      (lib.mkIf (cfg.hot-reload.enable) (lib.mkMerge [
        {
          hm.theme.hot-reload.scriptParts = lib.mkMerge [
            ''
              cp -rf "$directory/hypr/hyprland_colorschemes/$1.conf" "$directory/hypr/hyprland_colorscheme.conf"
              cp -rf "$directory/hypr/colorscheme_settings/$1.conf" "$directory/hypr/colorscheme_settings.conf"
            ''

            (lib.mkAfter ''
              hyprctl reload
            '')
          ];
        }
        colorFiles
        settingsFiles
      ]))
    ]
  ));
}
