{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.browsers;
in {
  imports = [
    ./firefox
    ./qutebrowser
  ];
  options.hm.browsers = {
    defaultBrowser = lib.mkOption {
      type = lib.types.enum ["firefox" "qutebrowser"];
      default = "firefox";
    };
  };
  config = {
    home.packages = with pkgs; [
      epiphany
    ];
    hm.browsers.qutebrowser.enable = true;
    programs.chromium.enable = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "${cfg.defaultBrowser}.desktop";
        "x-scheme-handler/http" = "${cfg.defaultBrowser}.desktop";
        "x-scheme-handler/https" = "${cfg.defaultBrowser}.desktop";
      };
    };
  };
}
