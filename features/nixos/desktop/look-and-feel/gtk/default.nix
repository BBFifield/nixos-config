{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop.theme;

  gtkThemeAttrs = {
    adw-gtk3 = "adw-gtk3";
    adw-gtk3-dark = "adw-gtk3";
    orchis = "orchis-theme";
  };
  gtkThemeEnums = lib.attrNames gtkThemeAttrs;
  defaultGtkTheme = lib.elemAt gtkThemeEnums 0;
  gtkThemeSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.enum (gtkThemeEnums ++ [config.tintednix.gtkTheme.name]);
        default = defaultGtkTheme;
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
  options.nixos.desktop.theme = {
    gtkTheme = mkOption {
      type = gtkThemeSubmodule;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.tintednix.gtkTheme.enable {
      nixos.desktop.theme.gtkTheme.name = config.tintednix.gtkTheme.name;
      nixos.desktop.theme.gtkTheme.package =
        config.tintednix.gtkTheme.package;
    })
    (lib.mkIf (!config.tintednix.gtkTheme.enable) {
      nixos.desktop.theme.gtkTheme.package = let
        pkgNameParts = lib.splitString "." gtkThemeAttrs.${cfg.gtkTheme.name};
      in
        lib.mkPkgName {} pkgs pkgNameParts;
    })
    {
      environment.etc = {
        "xdg/gtk-4.0/gtk.css".source = "${cfg.gtkTheme.package}/share/themes/${cfg.gtkTheme.name}/gtk-4.0/gtk.css";
        "xdg/gtk-4.0/gtk-dark.css".source = "${cfg.gtkTheme.package}/share/themes/${cfg.gtkTheme.name}/gtk-4.0/gtk-dark.css";
      };

      environment.systemPackages = [cfg.gtkTheme.package];
    }
  ];
}
