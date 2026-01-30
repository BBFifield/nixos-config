{pkgs, ...}: {
  home.packages = with pkgs; [
    darkly
    darkly-qt5
    catppuccin-qt5ct
    kdePackages.qt6ct
    libsForQt5.qt5ct
  ];

  qt.enable = true;

  xdg.configFile = {
    "qt5ct/qt5ct.conf".source = ./qt5/qt5ct.conf;
    "qt6ct/qt6ct.conf".source = ./qt6/qt6ct.conf;
    "qt6ct/style-colors.conf".source = ./qt6/qt6ct.conf;
  };
}
