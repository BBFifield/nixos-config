{
  config,
  pkgs,
  ...
}: {
  hm.tintednix = {
    enable = true;
    gtkTheme = {
      enable = true;
      enableGimpTheme = true;
    };
    enabledSchemes = with pkgs.base16; [ashes atelier-cave atelier-heath atelier-sulphurpool ayu-dark bespin blueish brushtrees-dark catppuccin-frappe catppuccin-latte catppuccin-macchiato catppuccin-mocha codeschool darkviolet dracula everforest everforest-dark-hard gruvbox-dark-hard gruvbox-dark-soft gruvbox-material-dark-hard gruvbox-material-dark-soft katy material-palenight moonlight nord rose-pine rose-pine-moon stella tokyo-night-dark tokyo-night-moon];
    defaultSchemeName = "catppuccin-mocha";
    targets = {
      firefox-dynamic = {
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
      firefox-userChrome = {
        enable = true;
        live.enable = true;
        templateSrc = pkgs.tintednix.root;
        templateName = "gtk4";
        path = ".mozilla/firefox/default/chrome/base16";
        schemeExtension = "scss";
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
      tauon = {
        enable = true;
        live = {
          enable = true;
        };
        templateSrc = pkgs.tintednix.root;
        templateName = "tauon";
        path = ".local/share/TauonMusicBox/theme";
        schemeFilename = "base16";
        schemeExtension = "ttheme";
      };
      vencord = {
        enable = true;
        live = {
          enable = true;
        };
        templateSrc = pkgs.tintednix.root;
        templateName = "vencord";
        path = ".config/vesktop/themes";
        schemeFilename = "colors";
        schemeExtension = "css";
      };
      uosc = {
        enable = true;
        live = {
          enable = true;
        };
        templateSrc = pkgs.tintednix.root;
        templateName = "uosc";
        path = ".config/mpv/script-opts";
        schemeFilename = "uosc";
        schemeExtension = "conf";
      };
      alacritty = {
        enable = true;
        live.enable = true;
        templateSrc = {
          url = "https://github.com/tinted-theming/tinted-terminal.git";
          rev = "d34c828c037ebaa7e871994376ed049f39075686";
          ref = "main";
        };
        templateName = "alacritty-base16";
        path = ".config/alacritty";
        schemeExtension = "toml";
      };
      ironbar = {
        enable = true;
        live = {
          enable = true;
          hooks = {
            hotReload = ''
              if systemctl --user is-active ironbar.service; then
                ironbar style load-css "$config_dir/ironbar/style.css"

                for i in $(seq 0 15); do
                  base=$(printf "%02X" "$i")   # 00 .. 0F
                  val="$(tintednix --get "base''${base}")"
                  [ -n "$val" ] && ironbar var set "base''${base}" "$val"
                done
                ironbar var set color_scheme "$_theme"
              fi
            '';
            onActivation = ''
              ${(import ../../features/home-manager/programs/ironbar/postStart.nix {inherit config pkgs;})}/bin/ironbar_post_start
              if systemctl --user is-active ironbar.service; then
                ${config.programs.ironbar.package}/bin/ironbar style load-css "/home/$(whoami)/.config/ironbar/style.css"
              fi
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
              if systemctl --user is-active swaync.service; then
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
      btop = {
        enable = true;
        live = {
          enable = true;
        };
        templateSrc = {
          url = "https://git.sr.ht/~blueingreen/base16-btop";
          rev = "69fd5f822cb3b144f6e4563c55422df81ef44733";
          ref = "main";
        };
        templateName = "body";
        path = ".config/btop/themes";
        schemeExtension = "theme";
      };
      shell = {
        enable = true;
        live = {
          enable = true;
          hooks.hotReload = "sh ~/.config/shell/colors.sh";
        };
        templateSrc = {
          url = "https://github.com/tinted-theming/tinted-shell.git";
          rev = "4b8579d356de78b4e7af5ea0b6a06a4cb464a016";
          ref = "refs/heads/main";
        };
        templateName = "base16";
        path = ".config/shell";
        schemeExtension = "sh";
      };
    };
  };
}
