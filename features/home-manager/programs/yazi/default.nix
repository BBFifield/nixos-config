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
in {
  options.hm.yazi = {
    enable = lib.mkEnableOption "Enable Yazi, the terminal file manager.";
    hotload = lib.mkOption {
      type = (import ../../submodules {inherit lib;}).hotload;
    };
  };

  config = let
    attrset = import ../../themes/colorschemeInfo.nix;
    themeNames = lib.attrNames attrset;
    getVariantNames = theme: lib.attrNames attrset.${theme}.variants;
  in
    lib.mkMerge [
      (
        lib.mkIf (cfg.hotload.enable)
        (
          let
            mkThemeFile = theme: variant: {
              xdg.configFile."yazi/themes/${theme}_${variant}.toml" = {
                source = tomlFormat.generate "theme" {
                  flavor = {
                    use = "${theme}-${variant}";
                  };
                };
              };
            };

            themeFilesList = lib.filter (item: item != null) (lib.concatMap (theme:
              lib.map (
                variant: let
                  #result = builtins.pathExists "${pkgs.yazi-flavors}/${theme}-${variant}.yazi";
                  hasPath = lib.foldl' (acc: x: acc || x) false (lib.map (path:
                    if (lib.hasInfix "${theme}-${variant}.yazi" path.url)
                    then true
                    else
                      (
                        if (builtins.pathExists "${builtins.fetchGit path}/${theme}-${variant}.yazi")
                        then true
                        else false
                      ))
                  flavorPaths);
                  #result = builtins.pathExists "${gitpath}/${theme}-${variant}.yazi";
                  file =
                    if hasPath
                    then (mkThemeFile theme variant)
                    else null;
                in
                  file
              ) (getVariantNames theme))
            themeNames);

            themeFiles = lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} themeFilesList;
          in
            lib.mkMerge [
              {
                hm.hotload.scriptParts = {
                  "5" = ''
                    rm $directory/yazi/theme.toml
                    cp -rf $directory/yazi/themes/$1.toml $directory/yazi/theme.toml
                  '';
                };
              }
              themeFiles
            ]
        )
      )
      # This file is created regardless
      {
        xdg.configFile."yazi/theme.toml" = {
          source = tomlFormat.generate "theme" {
            flavor.use = "${config.hm.theme.colorscheme.name}-${config.hm.theme.colorscheme.variant}";
          };
        };
      }
      {
        home.packages = with pkgs; [
          ueberzugpp
        ];
        programs.yazi = {
          enable = true;
          enableBashIntegration = true;
          flavors = lib.mkMerge [
            ((lib.listToAttrs (lib.filter (item: item != null) (lib.concatMap (theme:
              lib.map (
                variant: let
                  path = lib.foldl' (acc: x: if (x != null) then x else acc ) {} (lib.map (path:
                    if (lib.hasInfix "${theme}-${variant}.yazi" path.url)
                    then "${builtins.fetchGit path}"
                    else
                      (
                        if (builtins.pathExists "${builtins.fetchGit path}/${theme}-${variant}.yazi")
                        then "${builtins.fetchGit path}/${theme}-${variant}.yazi"
                        else null
                      ))
                  flavorPaths);
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
            themeNames))) )
          ];

          # "catppuccin-${cfg.variant}" = "${pkgs.yazi-flavors}/catppuccin-${cfg.variant}.yazi";
          settings = {
            manager = {
              show_hidden = true;
            };
          };
        };
      }
    ];
} 
