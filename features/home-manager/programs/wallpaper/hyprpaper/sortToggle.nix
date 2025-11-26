{
  config, # Keeps declaration DRY in hyprland bindings config
  pkgs,
}: let
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScript "wallpapersorttoggle" ''
    set -euo pipefail

    NOTIF_ID_FILE="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hyprpapernotif.id"

    notify_method() {
      if [ $1 -eq -1 ]; then
        ${notify-send} -a hyprpaper -p -t 5000 -i preferences-desktop-wallpaper-symbolic 'Wallpaper Sort Method Changed' "It is now $2" > "$NOTIF_ID_FILE"
      else
        ${notify-send} -a hyprpaper -r "$1" -t 5000 -i preferences-desktop-wallpaper-symbolic 'Wallpaper Sort Method Changed' "It is now $2"
      fi
    }

    notif_id="$(cat "$NOTIF_ID_FILE" 2>/dev/null || echo -1)"

    MODEFILE="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hyprpapercycle.mode"
    cur="$(cat "$MODEFILE" 2>/dev/null || echo "random")"
    if [ "$cur" = "ordered" ]; then
      printf 'random\n' > "$MODEFILE"
      printf 'mode=random\n'
      notify_method "$notif_id" "random"
    else
      printf 'ordered\n' > "$MODEFILE"
      printf 'mode=ordered\n'
      notify_method "$notif_id" "ordered"
    fi
  ''
