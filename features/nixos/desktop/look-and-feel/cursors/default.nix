{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop.theme;

  cursorThemeAttrs = {
    "BreezeX-Dark" = "icons.breezeXcursor";
  };
  cursorThemeEnums = builtins.attrNames cursorThemeAttrs;

  cursorSubmodule = types.submodule {
    options = {
      size = mkOption {
        type = types.ints.positive;
        default = 24;
      };
      name = mkOption {
        type = types.enum cursorThemeEnums;
        default = "BreezeX-Dark";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.icons.breezeXcursor;
      };
    };
  };
in {
  options.nixos.desktop.theme = {
    cursorTheme = mkOption {
      type = cursorSubmodule;
      default = {
        size = 24;
        name = "BreezeX-Dark";
        package = pkgs.icons.breezeXcursor;
      };
    };
  };

  config = {
    nixos.desktop.theme.cursorTheme.package = let
      pkgNameParts = lib.splitString "." cursorThemeAttrs.${cfg.cursorTheme.name};
    in
      mkPkgName {} pkgs pkgNameParts;

    environment.systemPackages = [cfg.cursorTheme.package]; # custom # Needs to be installed system-wide so sddm has access to it;
  };
}
