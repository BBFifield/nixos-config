{
  config,
  lib,
  pkgs,
  ...
}: let
  schemeAttrs = config.hm.tintednix.schemeVariantAndColors;

  defaultName = "${config.hm.tintednix.defaultSchemeName}";

  schemeNames = lib.attrNames schemeAttrs;

  mkScriptBinding = color_scheme: {
    bind = "SUPER, T, exec, tintednix --update ${color_scheme}";
  };
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
in {
  options.hm.hyprland = {
    shell = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = with lib.types; nullOr (enum ["tintednix"]);
            default = null;
            description = "Choose a customized shell.";
          };
          baseConfig = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };
        };
      };
      description = "Choose a customized shell.";
    };
  };
  config = (
    lib.mkIf (config.hm.tintednix.targets.hyprland.enable) (lib.mkMerge [
      {
        wayland.windowManager.hyprland = {
          settings = {
            source = [
              "${config.home.homeDirectory}/.config/hypr/${config.hm.tintednix.targets.hyprland.schemeFilename}.conf"
            ];
          };
        };
      }

      (lib.mkIf (config.hm.tintednix.targets.hyprland.live.enable) (lib.mkMerge [
        {
          wayland.windowManager.hyprland = {
            settings = {
              source = [
                "${config.home.homeDirectory}/.config/hypr/tintednix_binding.conf"
              ];
            };
          };
          hm.tintednix.live.hooks.hotReload = lib.mkMerge [
            ''
              cp -rf "$config_dir/hypr/tintednix_bindings/$_theme.conf" "$config_dir/hypr/tintednix_binding.conf"
            ''
          ];
        }
        scriptBindingFiles
      ]))
    ])
  );
}
