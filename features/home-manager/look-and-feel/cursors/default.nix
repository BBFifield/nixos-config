{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.theme;

  cursorThemeAttrs = {
    "BreezeX-Dark" = "icons.breezeXcursor";
  };
  cursorThemeEnums = lib.attrNames cursorThemeAttrs;
  cursorSubmodule = lib.types.submodule {
    options = {
      size = lib.mkOption {
        type = lib.types.ints.positive;
        default = 28;
      };
      name = lib.mkOption {
        type = lib.types.enum cursorThemeEnums;
        default = "BreezeX-Dark";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.${cursorThemeAttrs."BreezeX-Dark"}; #pkgs.icons.breezeXcursor;
      };
    };
  };
in {
  options.hm.theme = with lib; {
    cursorTheme = mkOption {
      type = cursorSubmodule;
    };
  };

  config = lib.mkMerge [
    {
      hm.theme.cursorTheme.package = let
        pkgNameParts = lib.splitString "." cursorThemeAttrs.${cfg.cursorTheme.name};
      in
        lib.mkPkgName {} pkgs pkgNameParts;

      home.packages = [cfg.cursorTheme.package]; # custom # Needs to be installed system-wide so sddm has access to it;
    }
  ];
}
