{
  pkgs,
  osConfig,
  lib,
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
  ];
in {
  imports = [../../features/home-manager ./config/tintednix.nix];

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
        mpv = {
          enable = true;
          enableScripts = true;
        };
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
