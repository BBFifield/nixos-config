{
  pkgs,
  osConfig,
  lib,
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
    arduino-ide
    #neovim
    # alacritty
    alacritty-theme
  ];
in {
  imports = [../../features/home-manager];

  # lib.mergeAttrsList or // does not work here instead of lib.mkMerge because firefox for example, is
  # defined in both the base config and one of the optionals to be merged. The attribute sets only merge nicely if both contain distinct attribute keys,
  # so in this case firefox.enable = false (implied and the default value) from the optional set overrides the earlier declaration. "lib.mkMerge" otoh, merges
  # explicitly declared values and ignores "implied".
  hm = lib.mkMerge [
    {
      firefox.enable = true;
      vscodium.enable = true;
      neovim = {
        enable = true;
        preset = "custom";
      };
    }
    (lib.optionalAttrs (osConfig.nixos.project.enableMutableConfigs) {
      enableMutableConfigs = true;
      projectPath = osConfig.nixos.project.path + "/features/home-manager/programs";
    })
    (lib.optionalAttrs (osConfig.nixos.desktop.plasma.enable) {
      firefox.style = "plasma";
      plasma.enable = true;
      konsole.enable = true;
      klassy.enable = true;
      kate.enable = true;
    })
    (lib.optionalAttrs (osConfig.nixos.desktop.gnome.enable) {
      firefox.style = "gnome";
      gnome-shell.enable = true;
      dconf.enable = true;
      vscodium.theme = "gnome";
    })
    (lib.optionalAttrs (osConfig.nixos.desktop.hyprland.enable) {
      firefox.style = "gnome";
      dconf.enable = true;
      hyprland = lib.mkMerge [
        {enable = true;}
        (lib.optionalAttrs (osConfig.nixos.desktop.hyprland.shell == "vanilla") {shell = "vanilla";})
        (lib.optionalAttrs (osConfig.nixos.desktop.hyprland.shell == "asztal") {shell = "asztal";})
        (lib.optionalAttrs (osConfig.nixos.desktop.hyprland.shell == "hyprpanel") {shell = "hyprpanel";})
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
