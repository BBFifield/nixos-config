{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
      ];
      config.common."org.freedesktop.impl.portal.FileChooser" = ["termfilechooser" "gtk"];
    };
    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=yazi-wrapper.sh
      default_dir=$HOME
      # Command needs to be wrapped in quotes to work
      env=TERMCMD='alacritty -T "Terminal Filechooser" -e'
      open_mode=suggested
      save_mode=suggested
    '';
  };
}
