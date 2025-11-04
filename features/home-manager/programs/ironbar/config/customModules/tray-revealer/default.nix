{
  config,
  lib,
  pkgs,
}: ''
  $tray_revealer = {
    type = "custom"
    name = "trayRevealer"
    bar = [
      {
        type = "button"
        on_click = "!${./tray_toggle.sh}"
        label = "#tray_icon"
      }
    ]
  }
''
