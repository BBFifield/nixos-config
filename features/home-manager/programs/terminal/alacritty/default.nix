{
  config,
  pkgs,
  lib,
  ...
}: let
  family = "JetBrainsMono Nerd Font";
  cfg = config.hm.alacritty;
  tomlFormat = pkgs.formats.toml {};

  settings = {
    font = {
      size = 11.0;
      bold = {
        inherit family;
        style = "Bold";
      };
      bold_italic = {
        inherit family;
        style = "Bold Italic";
      };
      italic = {
        inherit family;
        style = "Italic";
      };
      normal = {
        inherit family;
        style = "Regular";
      };
    };
    window = {
      opacity = 0.9;
    };
  };
in {
  options.hm.alacritty = {
    hot-reload = lib.mkOption {
      type = (import ../../../submodules {inherit lib;}).hot-reload;
    };
  };
  config = lib.mkMerge [
    (
      lib.mkIf (cfg.hot-reload.enable)
      (
        let
          attrset = import ../../../lookAndFeel/colorschemeInfo.nix;
          themeNames = lib.attrNames attrset;
          getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

          mkThemeFile = theme: variant: {
            xdg.configFile."alacritty/alacritty-themes/${theme}_${variant}.toml" = {
              source = tomlFormat.generate "alacritty-theme" {
                import = let
                  hasPackage = lib.hasAttr "${theme}_${variant}" pkgs.alacritty-theme;
                  package =
                    if hasPackage
                    then pkgs.alacritty-theme."${theme}_${variant}"
                    else pkgs.alacritty-theme."${theme}";
                in [
                  package
                ];
              };
            };
          };
          themeFilesList = lib.concatMap (theme: lib.map (variant: mkThemeFile theme variant) (getVariantNames theme)) themeNames;

          themeFiles = lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} themeFilesList;
        in
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
      xdg.configFile."alacritty/alacritty-theme.toml" = {
        source = tomlFormat.generate "alacritty-theme" {
          import = let
            hasPackage = lib.hasAttr "${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}" pkgs.alacritty-theme;
            package =
              if hasPackage
              then pkgs.alacritty-theme."${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}"
              else pkgs.alacritty-theme."${config.hm.theme.colorscheme.name}";
          in [
            package
          ];
        };
      };
    }
    {
      programs.alacritty = {
        enable = true;
        settings = lib.mkMerge [
          {
            import = ["${config.home.homeDirectory}/.config/alacritty/alacritty-theme.toml"];
          }
          settings
        ];
      };
    }
  ];
}
