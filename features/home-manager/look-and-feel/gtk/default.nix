{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.theme;

  gtkThemeAttrs = {
    adw-gtk3 = "adw-gtk3";
    adw-gtk3-dark = "adw-gtk3";
    orchis = "orchis-theme";
    Breeze = "kdePackages.breeze";
  };
  gtkThemeEnums = lib.attrNames gtkThemeAttrs;
  defaultGtkTheme = lib.elemAt gtkThemeEnums 0;
  gtkThemeSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.enum (gtkThemeEnums ++ [config.hm.tintednix.gtkTheme.name]);
        description = ''Which gtk theme to enable fir the UI. Note that enabling the tintednix gtk theme option will override any declaration you make here.'';
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.${gtkThemeAttrs.${defaultGtkTheme}};
        description = ''Which gtk theme to install mapped from the gtkTheme.name option. Note that enabling the tintednix gtk theme option will override any declaration you make here.'';
      };
    };
  };
in {
  options.hm.theme = with lib; {
    gtkTheme = mkOption {
      type = gtkThemeSubmodule;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.hm.tintednix.gtkTheme.enable {
      hm.theme.gtkTheme.name = config.hm.tintednix.gtkTheme.name;
      hm.theme.gtkTheme.package =
        config.hm.tintednix.gtkTheme.package;
    })
    (lib.mkIf (!config.hm.tintednix.gtkTheme.enable) {
      hm.theme.gtkTheme.package = let
        pkgNameParts = lib.splitString "." gtkThemeAttrs.${cfg.gtkTheme.name};
      in
        lib.mkPkgName {} pkgs pkgNameParts;
    })
    {
      xdg.configFile = {
        "gtk-4.0/gtk.css".source = "${config.hm.tintednix.gtkTheme.package}/share/themes/${cfg.gtkTheme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${config.hm.tintednix.gtkTheme.package}/share/themes/${cfg.gtkTheme.name}/gtk-4.0/gtk-dark.css";
        "gtk-4.0/assets" = {
          source = "${config.hm.tintednix.gtkTheme.package}/share/themes/${cfg.gtkTheme.name}/gtk-4.0/assets";
          recursive = true;
        };
      };

      home.packages = [cfg.gtkTheme.package];
    }
  ];
}
