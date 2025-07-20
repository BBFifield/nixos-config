# Use command "fc-list : family style" to see a list of fonts on your system.
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

  nfAttrs = {
    fira-code = {name = "FiraCode Nerd Font";};
    victor-mono = {name = "VictorMono Nerd Font";};
    iosevka-term = {name = "IosevkaTerm Nerd Font";};
    jetbrains-mono = {name = "JetBrainsMono Nerd Font";};
    iosevka = {name = "Iosevka Nerd Font";};
    roboto-mono = {name = "RobotoMono Nerd Font";};
    caskaydia-cove = {name = "CaskaydiaCove Nerd Font Mono";};
  };
  nfToFetch = builtins.attrNames nfAttrs;
  nfEnums = with builtins; attrValues (mapAttrs (name: value: value.name) nfAttrs);

  cursorThemeAttrs = {
    "BreezeX-Dark" = "icons.breezeXcursor";
  };
  cursorThemeEnums = builtins.attrNames cursorThemeAttrs;

  fontsSubmodule = types.submodule {
    options = {
      defaultMonospace = mkOption {
        type = types.enum nfEnums;
        default = "JetBrainsMono Nerd Font";
      };
    };
  };
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
    gtkTheme = mkOption {
      type = gtkThemeSubmodule;
    };
    iconTheme = mkOption {
      type = iconThemeSubmodule;
    };
    fonts = mkOption {
      type = fontsSubmodule;
      default = {
        defaultMonospace = "JetBrainsMono Nerd Font";
      };
    };
    cursorTheme = mkOption {
      type = cursorSubmodule;
      default = {
        size = 24;
        name = "BreezeX-Dark";
        package = pkgs.icons.breezeXcursor;
      };
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
      fonts.fontconfig = {
        enable = true;
        defaultFonts.monospace = [cfg.fonts.defaultMonospace];
      };

      environment.etc = {
        "xdg/gtk-4.0/gtk.css".source = "${cfg.gtkTheme.package}/share/themes/${cfg.gtkTheme.name}/gtk-4.0/gtk.css";
        "xdg/gtk-4.0/gtk-dark.css".source = "${cfg.gtkTheme.package}/share/themes/${cfg.gtkTheme.name}/gtk-4.0/gtk-dark.css";
      };

      nixos.desktop.theme.iconTheme.package = pkgs.${builtins.head (filterByValue cfg.iconTheme.name iconThemeAttrs)};

      nixos.desktop.theme.cursorTheme.package = let
        pkgNameParts = lib.splitString "." cursorThemeAttrs.${cfg.cursorTheme.name};
      in
        mkPkgName {} pkgs pkgNameParts;

      fonts.packages = with pkgs; let
        nfPkgs = lib.map (nf: nerd-fonts.${nf}) nfToFetch;
      in
        nfPkgs ++ [iosevka];

      environment.systemPackages = let
        filterByValue = value: attrs: builtins.filter (name: attrs.${name} == value) (lib.attrNames attrs); # Get icon package to be installed
        # iconTheme = pkgs.${builtins.head (filterByValue cfg.iconTheme iconThemeAttrs)};
        iconDependencies = lib.optionals (cfg.iconTheme.name == "MoreWaita") [pkgs.adwaita-icon-theme]; #MoreWaita requires Adwaita to also be installed
        iconThemePkgs = [cfg.iconTheme.package] ++ iconDependencies;
      in
        [cfg.gtkTheme.package]
        ++ iconThemePkgs
        ++ [cfg.cursorTheme.package]; # custom # Needs to be installed system-wide so sddm has access to it;
    }
  ];
}
