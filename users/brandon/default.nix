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
        live.enable = true;
        hidpi.enable = sysCfg.desktop.hidpi.enable;

        browsers.firefox.enable = true;
        vscodium.enable = true;
        neovim = {
          enable = true;
          pluginManager = "lazy";
        };
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
        browsers.firefox = {
          style = "hyprland";
          live.enable = true;
        };
        dconf.enable = true;
        yazi.live.enable = true;
        theme = {
          gtkTheme.name = "adw-gtk3-dark";
          iconTheme = "MoreWaita";
        };
        hyprland = lib.mkMerge [
          {enable = true;}
          (lib.optionalAttrs (sysCfg.desktop.hyprland.shell == "tintednix") {
            shell = {
              name = "tintednix";
              live.enable = true;
            };
          })
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
        themeExtension = "toml";
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
        themeExtension = "conf";
      };
      qutebrowser = {
        enable = true;
        live.enable = true;
        templateRepo = {
          url = "https://github.com/tinted-theming/base16-qutebrowser.git";
          rev = "6253558595c15c29689b4343de6303f6743f5831";
          ref = "main";
        };
        themeFilename = "colors";
        path = ".config/qutebrowser";
        themeExtension = "py";
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
        themeExtension = "toml";
      };
      ironbar = {
        enable = true;
        live = {
          enable = true;
          hooks = {
            hotReload = ''ironbar load-css "$directory/ironbar/style.css"'';
            onActivation = ''
              (
                XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
                if [[ -S "$XDG_RUNTIME_DIR/ironbar-ipc.sock" ]]; then
                  ${pkgs.ironbar}/bin/ironbar load-css "${config.home.homeDirectory}/.config/ironbar/style.css"
                fi
              )
            '';
          };
        };
        templateRepo = {
          url = "https://github.com/tinted-theming/base16-waybar.git";
          rev = "26d41f3550da17ebdd14b6b2bc4fdf86c543735e";
          ref = "main";
        };
        path = ".config/ironbar";
        themeExtension = "css";
      };
      walker = {
        enable = true;
        live = {
          enable = true;
          hooks.hotReload = ''walker --theme style'';
        };
        templateRepo = {
          url = "https://github.com/samme/base16-styles.git";
          rev = "8db4f00ca9e5575ba52d98a204ee44a53e13d546";
          ref = "master";
        };
        templateName = "css-variables";

        path = ".config/walker/themes";
        themeExtension = "css";
      };
      shell = {
        enable = true;
        live = {
          enable = true;
          hooks.hotReload = "sh ~/.config/bash/colors.sh";
        };
        templateRepo = {
          url = "https://github.com/tinted-theming/tinted-shell.git";
          rev = "60c80f53cd3d97c25eb0580e40f0b9de84dac55f";
          ref = "main";
        };
        templateName = "base16";
        path = ".config/shell";
        themeExtension = "sh";
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
