{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.theme;

  iconThemeAttrs = {
    "icons.breezeChameleon" = ''"Breeze-Round-Chameleon Dark Icons"'';
    "morewaita-icon-theme" = "MoreWaita";
    "tela-icon-theme" = "Tela";
    "qogir-icon-theme" = "Qogir";
  };
  iconThemeEnums = lib.attrValues iconThemeAttrs;
in {
  options.hm.theme = with lib; {
    iconTheme = mkOption {
      type = types.enum iconThemeEnums;
    };
  };

  config = lib.mkMerge [
    {
      home.packages = let
        filterByValue = value: attrs: builtins.filter (name: attrs.${name} == value) (lib.attrNames attrs); # Get icon package to be installed
        iconTheme = pkgs.${builtins.head (filterByValue cfg.iconTheme iconThemeAttrs)};
        iconDependencies = lib.optionals (cfg.iconTheme == "MoreWaita") [pkgs.adwaita-icon-theme]; #MoreWaita requires Adwaita to also be installed
        iconThemePkgs = [iconTheme] ++ iconDependencies;
      in
        iconThemePkgs;
    }
  ];
}
