{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true;
      env = {
        XCURSOR_THEME = config.nixos.desktop.theme.cursorTheme.name;
        XCURSOR_SIZE = toString config.nixos.desktop.theme.cursorTheme.size;
        GDK_SCALE = "2";
        GDK_BACKEND = "x11";
      };
      args = [
        "--mouse-sensitivity 2.0"
        "--cursor-scale-height 2160"
      ];
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
}
