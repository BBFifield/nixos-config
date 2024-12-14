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
      '';
    };
  };
}
