{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.browsers.qutebrowser;
in {
  options.hm.browsers.qutebrowser = {
    enable = lib.mkEnableOption "Enable qutebrowser.";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [python313Packages.adblock];
    programs.qutebrowser = {
      enable = true;
      extraConfig = ''
        config.source('colors.py')
        c.fonts.default_family = "${config.hm.theme.fonts.defaultMonospace}"
        c.fonts.default_size = '11pt'
        c.qt.highdpi = True
        c.statusbar.position = 'top'
        c.statusbar.padding = {'top': 2, 'bottom': 2, 'left': 0, 'right': 0}
        c.tabs.padding = {'top': 4, 'bottom': 4, 'left': 0, 'right': 0}

        c.colors.webpage.darkmode.enabled = True
        c.colors.webpage.preferred_color_scheme = 'dark'

        c.content.autoplay = False
        c.scrolling.smooth = False

        config.bind(',m', 'spawn umpv {url}')
        config.bind(',M', 'hint links spawn umpv {hint-url}')
        config.bind(';M', 'hint --rapid links spawn umpv {hint-url}')
      '';
    };
  };
}
