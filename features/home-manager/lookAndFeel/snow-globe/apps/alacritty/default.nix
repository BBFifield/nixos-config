{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.snow-globe.targets.alacritty;
  snow-globe.lib = import ../../lib {inherit config pkgs lib;};
  template = {
    url = "https://github.com/aarowill/base16-alacritty.git";
    rev = "c95c200b3af739708455a03b5d185d3d2d263c6e";
    ref = "master";
  };
in {
  options.snow-globe.targets.alacritty = {
    enable = lib.mkEnableOption "Enable snow-globe to theme alacritty.";
    hot-reload = lib.mkOption {
      type = (import ../../../../submodules {inherit lib;}).hot-reload;
    };
  };
  config = let
    configs = lib.map (scheme: snow-globe.lib.mkConfigFromTemplate scheme template) config.snow-globe.enabledSchemes;

    themeFilesList = lib.map (config: {configFile."alacritty/alacritty-themes/${config.schemeName}.toml".source = config.generatedConfig;}) configs;

    themeFiles = {xdg = lib.mkMerge [(lib.foldl' (acc: item: {configFile = acc.configFile // item.configFile;}) {configFile = {};} themeFilesList)];};
  in
    lib.mkMerge [
      (
        lib.mkIf (cfg.hot-reload.enable)
        (
          lib.mkMerge [
            {
              hm.theme.hot-reload.scriptParts = lib.mkMerge [
                (lib.mkOrder 20 ''
                  rm $directory/alacritty/alacritty-theme.toml
                  cp -rf $directory/alacritty/alacritty-themes/$1.toml $directory/alacritty/alacritty-theme.toml
                '')
              ];
            }
            themeFiles
          ]
        )
      )
      # This file is created regardless
      {
        xdg.configFile."alacritty/alacritty-theme.toml" = let
          defaultScheme = config.snow-globe.defaultScheme;
          defaultConfig = snow-globe.lib.mkConfigFromTemplate defaultScheme template;
        in {
          source = defaultConfig.generatedConfig;
        };
      }
    ];
}
