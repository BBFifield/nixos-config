{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.hyprland;
in {
  imports = [
    ./config/accessibility.nix
    ./config/appearance.nix
    ./config/startup.nix
    ./config/bindings.nix
    ./config/displays.nix
    ./config/tintednix.nix

    ./hypridle
    ./hyprlock
    ./hyprsunset
  ];

  options.hm.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration via home-manager";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          loupe
          baobab
        ]
        ++ lib.optionals (config.wayland.windowManager.hyprland.settings.experimental.xx_color_management_v4) [vulkan-hdr-layer-kwin6]; #For HDR https://wiki.hyprland.org/Configuring/Variables/#experimental ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk "filename";
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = [
        "hyprland"
        "gtk"
      ];
    };

    hm = {
      wallpaper.daemon = "wpaperd";
      hyprland.hyprsunset.enable = true;
      hyprland.hyprlock.enable = true;
      walker.enable = true;

      satty.enable = true;
      ironbar = {
        enable = true;
        customModules = ["walker" "tray-revealer" "tools" "stats" "power"];
      };
      wleave.enable = true;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      settings = {
        env = [
          "GDK_BACKEND,wayland,x11,*"
          #uwsm users don’t need to explicitly set XDG environment variables, as uwsm sets them automatically.

          "QT_QPA_PLATFORM,wayland;xcb"
        ];
      };
    };
  };
}
