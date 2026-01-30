{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop.theme;

  filterByValue = value: attrs: builtins.filter (name: attrs.${name} == value) (lib.attrNames attrs); # Get icon package to be installed

  iconThemeAttrs = {
    "icons.breezeChameleon" = ''"Breeze-Round-Chameleon Dark Icons"'';
    "morewaita-icon-theme" = "MoreWaita";
    "tela-icon-theme" = "Tela";
    "qogir-icon-theme" = "Qogir";
  };
  iconThemeEnums = lib.attrValues iconThemeAttrs;
  defaultIconTheme = lib.elemAt iconThemeEnums 0;
  iconThemeSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.enum iconThemeEnums;
        default = defaultIconTheme;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.${builtins.head (filterByValue defaultIconTheme iconThemeAttrs)};
      };
    };
  };
in {
  options.nixos.desktop.theme = {
    iconTheme = mkOption {
      type = iconThemeSubmodule;
    };
  };

  config = {
    nixos.desktop.theme.iconTheme.package = pkgs.${builtins.head (filterByValue cfg.iconTheme.name iconThemeAttrs)};

    environment.systemPackages = let
      iconDependencies = lib.optionals (cfg.iconTheme.name == "MoreWaita") [pkgs.adwaita-icon-theme]; #MoreWaita requires Adwaita to also be installed
      iconThemePkgs = [cfg.iconTheme.package] ++ iconDependencies;
    in
      iconThemePkgs;
  };
}
