{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop;
in {
  config = lib.mkIf (cfg.hyprland.enable) {
    environment.systemPackages = with pkgs; [
      kdePackages.qtwayland #QT apps will not open under wayland mode otherwise
      kdePackages.qt6ct
      libsForQt5.qt5ct
      catppuccin-qt5ct
      darkly
      darkly-qt5
    ];
    environment.pathsToLink = ["/share/qt5ct/colors" "/share/qt6ct/colors"];
  };
}
