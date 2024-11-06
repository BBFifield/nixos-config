{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.yazi;
  tomlFormat = pkgs.formats.toml {};

  flavorPaths = [
    {
      url = "https://github.com/yazi-rs/flavors.git";
      ref = "main";
      rev = "1f54993b7a3f4b9c551531e019d82c7a609c6cd0";
    }
    {
      url = "https://github.com/bennyyip/gruvbox-dark.yazi.git";
      name = "gruvbox-dark.yazi";
      ref = "main";
      rev = "c204853de7a78bc99ea628e51857ce65506468db";
    }
  ];

  attrset = import ../../lookAndFeel/colorschemeInfo.nix;
  themeNames = lib.attrNames attrset;
  getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

  queryGit = theme: variant:
    lib.foldl' (acc: x:
      if (x != null)
      then x
      else acc) {} (lib.map (path:
      if (lib.hasInfix "${theme}-${variant}.yazi" path.url)
      then "${builtins.fetchGit path}"
      else
        (
          if (builtins.pathExists "${builtins.fetchGit path}/${theme}-${variant}.yazi")
          then "${builtins.fetchGit path}/${theme}-${variant}.yazi"
          else null
        ))
    flavorPaths);

  mkThemeFileIfHasPath = theme: variant: path:
    if (queryGit theme variant) != {}
    then mkThemeFile theme variant path
    else null;

  mkThemeFile = theme: variant: path: {
    xdg.configFile."${path}.toml" = {
      source = tomlFormat.generate "theme" {
        flavor = {
          use = "${theme}-${variant}";
        };
      };
    };
  };

  defaultTheme = config.hm.theme.colorscheme.name;
  defaultVariant = config.hm.theme.colorscheme.variant;

  defaultThemeHasPath = queryGit defaultTheme defaultVariant;
in {
  options.hm.yazi = {
    enable = lib.mkEnableOption "Enable Yazi, the terminal file manager.";
    hot-reload = lib.mkOption {
      type = (import ../../submodules {inherit lib;}).hot-reload;
    };
  };

  config = lib.mkMerge [
    (
      lib.mkIf (cfg.hot-reload.enable)
      (
        let
          themeFilesList = lib.filter (item: item != null) (lib.concatMap (theme:
            lib.map (
              variant: let
                file = mkThemeFileIfHasPath theme variant "yazi/themes/${theme}_${variant}";
              in
                file
            ) (getVariantNames theme))
          themeNames);

          mkthemeFiles = lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} themeFilesList;
        in
          lib.mkMerge [
            {
              hm.theme.hot-reload.scriptParts = lib.mkMerge [
                (lib.mkOrder 25 ''
                  rm $directory/yazi/theme.toml
                  cp -rf $directory/yazi/themes/$1.toml $directory/yazi/theme.toml
                '')
              ];
            }
            mkthemeFiles
          ]
      )
    )
    #This is the default file created regardless of hot-reloading being enabled
    (
      lib.mkIf (defaultThemeHasPath != {}) (mkThemeFile defaultTheme defaultVariant "yazi/theme")
    )
    #This ensures no theme is left over from a previous generation
    (
      lib.mkIf (defaultThemeHasPath == {}) {
        home.activation.yazi = lib.hm.dag.entryAfter ["writeBoundary"] ''
          if test -f "${config.home.homeDirectory}/.config/yazi/theme.toml"; then
            rm "${config.home.homeDirectory}/.config/yazi/theme.toml"
          fi
        '';
      }
    )
    {
      home.packages = with pkgs; [
        ueberzugpp
      ];
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        flavors = lib.mkMerge [
          (lib.mkIf (config.hm.yazi.hot-reload.enable) (
            lib.listToAttrs (lib.filter (item: item != null) (lib.concatMap (theme:
              lib.map (
                variant: let
                  path = queryGit theme variant;
                  flavor =
                    if (path != {})
                    then {
                      name = "${theme}-${variant}";
                      value = path;
                    }
                    else null;
                in
                  flavor
              ) (getVariantNames theme))
            themeNames))
          ))

          (lib.mkIf (!config.hm.yazi.hot-reload.enable) (
            let
              path = queryGit defaultTheme defaultVariant;
              flavor =
                if (path != {})
                then {
                  name = "${defaultTheme}-${defaultVariant}";
                  value = path;
                }
                else null;
            in
              flavor
          ))
        ];

        settings = {
          manager = {
            show_hidden = true;
          };
        };
      };
    }
  ];
}
