{...}: {
  programs.vesktop = {
    enable = true;
    settings = {
      appBadge = true;
      arRPC = true;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      discordBranch = "stable";
      hardwareAcceleration = true;
      minimizeToTray = false;
      splashBackground = "#000000";
      splashColor = "#ffffff";
      splashTheming = false;
      staticTitle = true;
      tray = true;
      disableSmoothScroll = true;
      enableMenu = true;
      enableSplashScreen = false;
    };
    vencord = {
      useSystem = true;
    };
  };
  xdg.configFile = {
    "vesktop/settings/settings.json".source = ./settings.json;
    "vesktop/themes/custom.theme.css".source = ./style/base16.theme.css;
  };
}
