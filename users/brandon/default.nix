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
    gh
    efibootmgr
    gptfdisk
    discord
    slack
    _1password-gui
    shellcheck
    fastfetch
    bluetui # bluetooth
    nmgui #wifi ui
    fragments
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
          # gtkTheme.name = "adw-gtk3-dark";
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
          iconTheme = "Tela";
        };
        hyprland = lib.mkMerge [
          {
            enable = true;
            displayOutputs = sysCfg.desktop.hyprland.displayOutputs;
          }
          (lib.optionalAttrs (sysCfg.desktop.hyprland.shell == "tintednix") {shell.name = "tintednix";})
        ];
        vscodium.theme = "gnome";
      })
      {
        tintednix = {
          enable = true;
          gtkTheme.enable = true;
          enabledSchemes = with pkgs.base16; [ashes atelier-cave atelier-heath atelier-sulphurpool ayu-dark bespin blueforest blueish brushtrees-dark catppuccin-frappe catppuccin-latte catppuccin-macchiato catppuccin-mocha codeschool darkviolet dracula everforest everforest-dark-hard gruvbox-dark-hard gruvbox-dark-soft gruvbox-material-dark-hard gruvbox-material-dark-soft katy material-palenight moonlight nord rose-pine rose-pine-moon stella tokyo-night-dark tokyo-night-moon];
          defaultSchemeName = "catppuccin-mocha";
          targets = {
            firefox = {
              enable = true;
              live.enable = true;
              templateSrc = {
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
              templateSrc = {
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
              templateSrc = {
                url = "https://github.com/tinted-theming/base16-qutebrowser.git";
                rev = "6253558595c15c29689b4343de6303f6743f5831";
                ref = "main";
              };
              path = ".config/qutebrowser";
              schemeFilename = "colors";
              schemeExtension = "py";
            };
            alacritty = {
              enable = true;
              live.enable = true;
              templateSrc = {
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
                    ironbar style load-css "$config_dir/ironbar/style.css"

                    for base in {00..0F}; do
                      val="$($tintednix --get "base0''${base}")"
                      ironbar var set b"ase0''${base}" "$val"
                    done
                    ironbar var set color_scheme "$_theme"
                  '';
                  onActivation = ''
                    ${(import ../../features/home-manager/programs/ironbar/postStart.nix {inherit config pkgs;})}/bin/ironbar_post_start
                    ${config.programs.ironbar.package}/bin/ironbar style load-css "/home/$(whoami)/.config/ironbar/style.css"
                  '';
                };
              };
              templateSrc = pkgs.tintednix.root;
              templateName = "gtk4";
              path = ".config/ironbar";
              schemeExtension = "scss";
            };
            walker = {
              enable = true;
              live = {
                enable = true;
              };
              templateSrc = pkgs.tintednix.root;
              templateName = "gtk4";
              path = ".config/walker/themes/style";
              schemeExtension = "scss";
            };
            swaync = {
              enable = true;
              live = {
                enable = true;
                hooks = {
                  hotReload = ''
                    ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
                  '';
                  onActivation = ''
                    if [[ $(systemctl --user status swaync.service | grep 'active (running)') ]]; then
                      systemctl --user stop swaync.service;
                      ${pkgs.swaynotificationcenter}/bin/swaync -s "/home/$(whoami)/.config/swaync/style.css"
                    else
                      ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
                    fi
                  '';
                };
              };
              templateSrc = pkgs.tintednix.root;
              templateName = "gtk4";
              path = ".config/swaync";
              schemeExtension = "scss";
            };
            wleave = {
              enable = true;
              live = {
                enable = true;
              };
              templateSrc = pkgs.tintednix.root;
              templateName = "gtk4";
              path = ".config/wleave/gtk-4.0";
              schemeExtension = "scss";
            };
            "gtk-3.0" = {
              enable = true;
              live = {
                enable = true;
              };
              templateSrc = pkgs.tintednix.root;
              templateName = "gtk3";
              path = ".config/gtk-3.0";
              schemeFilename = "colors";
              schemeExtension = "scss";
            };
            "gtk-4.0" = {
              enable = true;
              live = {
                enable = true;
              };
              templateSrc = pkgs.tintednix.root;
              path = ".config/gtk-4.0";
              templateName = "gtk4";
              schemeFilename = "colors";
              schemeExtension = "scss";
            };
            "epiphany" = {
              enable = true;
              live = {
                enable = true;
              };
              templateSrc = pkgs.tintednix.root;
              path = ".local/share/epiphany";
              templateName = "epiphany";
              schemeFilename = "user-stylesheet";
              schemeExtension = "scss";
            };
            shell = {
              enable = true;
              live = {
                enable = true;
                hooks.hotReload = "sh ~/.config/shell/colors.sh";
              };
              templateSrc = {
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
      }
    ];

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
