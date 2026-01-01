{
  config,
  pkgs,
  ...
}: let
  cursorTheme = {
    name = config.hm.theme.cursorTheme.name;
    size = config.hm.theme.cursorTheme.size;
    package = config.hm.theme.cursorTheme.package;
  };
in {
  xdg.configFile."uwsm/env".text = ''
    export XCURSOR_SIZE=${toString cursorTheme.size}
    export XCURSOR_THEME=${cursorTheme.name}
    export GDK_SCALE=2
    export QT_QPA_PLATFORMTHEME=qt6ct
    export GDK_BACKEND=wayland,x11,*
    export QT_QPA_PLATFORM=wayland;xcb
    export AVALONIA_GLOBAL_SCALE_FACTOR=2
    export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
  '';
  # Avalonia is used in ryujinx/ryubing for example
  xdg.configFile."uwsm/env-hyprland".text = ''
    export HYPRCURSOR_SIZE=${toString cursorTheme.size}
    export HYPRCURSOR_THEME=${cursorTheme.name}
  '';
}
