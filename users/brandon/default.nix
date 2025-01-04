{
  pkgs,
  osConfig,
  lib,
  config,
  ...
}: let
  username = "brandon";
  homeDirectory = "/home/${username}";

  defaultPkgs = with pkgs; [
    git
    gh
    efibootmgr
    gptfdisk
    discord
    _1password-gui
    shellcheck
    bluetui
  ];
in {
  imports = [../../features/home-manager];

  # lib.mergeAttrsList or // does not work here instead of lib.mkMerge because firefox for example, is
  # defined in both the base config and one of the optionals to be merged. The attribute sets only merge nicely if both contain distinct attribute keys,
  # so in this case firefox.enable = false (implied and the default value) from the optional set overrides the earlier declaration. "lib.mkMerge" otoh, merges
  # explicitly declared values and ignores implicit.
  hm = let
    sysCfg = osConfig.nixos;
  in
    lib.mkMerge [
      ###### BASE CONFIG ######
      {
        hidpi.enable = sysCfg.desktop.hidpi.enable;

        browsers.firefox.enable = true;
        vscodium.enable = true;
        neovim.enable = true;
        theme = {
          gtkTheme.name = "adw-gtk3-dark";
          fonts.defaultMonospace = sysCfg.desktop.theme.fonts.defaultMonospace;
          cursorTheme = {
            name = sysCfg.desktop.theme.cursorTheme.name;
            size = sysCfg.desktop.theme.cursorTheme.size;
          };
        };
      }
      ###### PLASMA CONFIG ######
      (lib.optionalAttrs (sysCfg.desktop.plasma.enable) {
        browsers.firefox.style = "plasma";
        plasma.enable = true;
        konsole.enable = true;
        klassy.enable = true;
        kate.enable = true;
        theme = {
          gtkTheme.name = "Breeze";
          iconTheme = ''"Breeze-Round-Chameleon Dark Icons"'';
        };
      })
      ###### GNOME-SHELL CONFIG ######
      (lib.optionalAttrs (sysCfg.desktop.gnome.enable) {
        browsers.firefox.style = "gnome";
        gnome-shell.enable = true;
        dconf.enable = true;
        vscodium.theme = "gnome";
        theme = {
          gtkTheme.name = "adw-gtk3-dark";
          iconTheme = "MoreWaita";
        };
      })
      ###### HYPRLAND CONFIG ######
      (lib.optionalAttrs (sysCfg.desktop.hyprland.enable) {
        browsers.firefox.style = "hyprland";
        dconf.enable = true;
        theme = {
          gtkTheme.name = "adw-gtk3-dark";
          iconTheme = "MoreWaita";
        };
        hyprland = lib.mkMerge [
          {enable = true;}
          (lib.optionalAttrs (sysCfg.desktop.hyprland.shell == "tintednix") {shell.name = "tintednix";})
          (lib.optionalAttrs (sysCfg.desktop.hyprland.shell == "asztal") {shell = "asztal";})
          (lib.optionalAttrs (sysCfg.desktop.hyprland.shell == "hyprpanel") {shell = "hyprpanel";})
        ];
        vscodium.theme = "gnome";
      })
    ];

  tintednix = {
    enable = true;
    enabledSchemes = with pkgs.base16; [catppuccin-frappe catppuccin-latte catppuccin-macchiato catppuccin-mocha dracula gruvbox-dark-hard];
    defaultScheme = "catppuccin-mocha";
    targets = {
      firefox = {
        enable = true;
        live.enable = true;
        templateRepo = {
          url = "https://github.com/BBFifield/firefox-native-base16.git";
          rev = "9f72a3caa05901f90849ed32da5c9e489b10f679";
          ref = "master";
        };
        path = ".mozilla";
        schemeExtension = "toml";
      };
      hyprland = {
        enable = true;
        live = {
          enable = true;
          hooks.hotReload = ''hyprctl reload'';
        };
        templateRepo = {
          url = "https://github.com/kirasok/base16-hyprland.git";
          rev = "2b66f94aaf45f5e03f588272dde7177552835b3b";
          ref = "main";
        };
        templateName = "colors";
        path = ".config/hypr";
        schemeExtension = "conf";
      };
      qutebrowser = {
        enable = true;
        live.enable = true;
        templateRepo = {
          url = "https://github.com/tinted-theming/base16-qutebrowser.git";
          rev = "6253558595c15c29689b4343de6303f6743f5831";
          ref = "main";
        };
        schemeFilename = "colors";
        path = ".config/qutebrowser";
        schemeExtension = "py";
      };
      alacritty = {
        enable = true;
        live.enable = true;
        templateRepo = {
          url = "https://github.com/aarowill/base16-alacritty.git";
          rev = "c95c200b3af739708455a03b5d185d3d2d263c6e";
          ref = "master";
        };
        templateName = "default-256";
        path = ".config/alacritty";
        schemeExtension = "toml";
      };
      ironbar = {
        enable = true;
        live = {
          enable = true;
          hooks = {
            hotReload = ''
              ironbar load-css "$directory/ironbar/style.css"
              ironbar var set color_scheme "$arg2"
              ironbar var set base00 "$($tintednix get base00)"
              ironbar var set base01 "$($tintednix get base01)"
              ironbar var set base02 "$($tintednix get base02)"
              ironbar var set base03 "$($tintednix get base03)"
              ironbar var set base04 "$($tintednix get base04)"
              ironbar var set base05 "$($tintednix get base05)"
              ironbar var set base06 "$($tintednix get base06)"
              ironbar var set base07 "$($tintednix get base07)"
              ironbar var set base08 "$($tintednix get base08)"
              ironbar var set base09 "$($tintednix get base09)"
              ironbar var set base0A "$($tintednix get base0A)"
              ironbar var set base0B "$($tintednix get base0B)"
              ironbar var set base0C "$($tintednix get base0C)"
              ironbar var set base0D "$($tintednix get base0D)"
              ironbar var set base0E "$($tintednix get base0E)"
              ironbar var set base0F "$($tintednix get base0F)"
            '';
            onActivation = ''
              ${pkgs.bash}/bin/bash ${(import ../../features/home-manager/programs/bars/ironbar/postStart.nix {inherit config pkgs;}).postStart}/bin/ironbar_post_start
              ${config.programs.ironbar.package}/bin/ironbar load-css "/home/$(whoami)/.config/ironbar/style.css"
            '';
          };
        };
        templateRepo = {
          url = "https://github.com/tinted-theming/base16-waybar.git";
          rev = "26d41f3550da17ebdd14b6b2bc4fdf86c543735e";
          ref = "main";
        };
        path = ".config/ironbar";
        schemeExtension = "css";
      };
      walker = {
        enable = true;
        live = {
          enable = true;
          # hooks.hotReload = ''walker --theme style'';
        };
        templateRepo = {
          url = "https://github.com/samme/base16-styles.git";
          rev = "8db4f00ca9e5575ba52d98a204ee44a53e13d546";
          ref = "master";
        };
        templateName = "css-variables";

        path = ".config/walker/themes";
        schemeExtension = "css";
      };
      shell = {
        enable = true;
        live = {
          enable = true;
          hooks.hotReload = "sh ~/.config/shell/colors.sh";
        };
        templateRepo = {
          url = "https://github.com/tinted-theming/tinted-shell.git";
          rev = "60c80f53cd3d97c25eb0580e40f0b9de84dac55f";
          ref = "main";
        };
        templateName = "base16";
        path = ".config/shell";
        schemeExtension = "sh";
      };
    };
  };

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages =
      defaultPkgs;
  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";
}
