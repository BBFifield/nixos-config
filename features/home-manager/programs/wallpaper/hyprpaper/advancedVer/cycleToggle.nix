{
  config,
  pkgs,
  ...
}: let
  hyprpaperCycle = "${(import ./hyprpaperCycle.nix {inherit pkgs;})}/bin/hyprpapercycle";
  wallpaperDir = "${config.home.homeDirectory}/Pictures/wallpapers";

  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScript "hyprpapercycletoggle" ''
    # Toggle hyprpapercycle status or switch mode
    # Usage:
    #   hyprpapercycletoggle           -> toggle running / start with opposite mode if stopped
    #   hyprpapercycletoggle next      -> advance to next wallpaper
    #   hyprpapercycletoggle prev      -> go to previous wallpaper

    ironbar_enabled=${
      if config.hm.ironbar.enable
      then "true"
      else "false"
    }

    ironbar_set_status() {
      if command -v ironbar >/dev/null 2>&1; then
        ironbar var set wallpaper_cycle_status "$1"
      fi
    }
    ironbar_toggle_icon_class() {
      if command -v ironbar >/dev/null 2>&1; then
        ironbar style toggle-class tools wallpaperCycleOn
      fi
    }
    notify_off() { ${notify-send} -a hyprpaper -t 5000 -i preferences-desktop-wallpaper-symbolic 'hyprpapercycle Off' 'Wallpaper cycle paused'; }
    notify_on()  { ${notify-send} -a hyprpaper -t 5000 -i preferences-desktop-wallpaper-symbolic 'hyprpapercycle On' 'Wallpaper cycle resumed'; }

    ironbar_do_off() { [ "$ironbar_enabled" = "true" ] || return 0; ironbar_set_status 'hyprpapercycle OFF'; ironbar_toggle_icon_class; }
    ironbar_do_on()  { [ "$ironbar_enabled" = "true" ] || return 0; ironbar_set_status 'hyprpapercycle ON'; ironbar_toggle_icon_class; }

    SCRIPT="${hyprpaperCycle}"
    WALLPAPER_DIR="${wallpaperDir}"
    INTERVAL="20"
    RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    PIDFILE="$RUNTIME_DIR/hyprpapercycle.pid"
    MODEFILE="$RUNTIME_DIR/hyprpapercycle.mode"
    CMDFIFO="$RUNTIME_DIR/hyprpapercycle.cmd"

    # parse arg for next/prev
    ACTION="''${1:-toggle}"

    # Prefer hyprpapercyclectl when present
    if command -v hyprpapercyclectl >/dev/null 2>&1; then
      case "$ACTION" in
        toggle)
          if hyprpapercyclectl status >/dev/null 2>&1 && hyprpapercyclectl status 2>&1 | grep -qi running; then
            hyprpapercyclectl toggle
            newmode="$(cat "$MODEFILE" 2>/dev/null || echo "unknown")"
            ${notify-send} -a hyprpaper -t 2000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Toggled wallpaper mode -> $newmode"
            exit 0
          else
            # start with opposite persisted mode
            if [ -f "$MODEFILE" ]; then
              prev="$(cat "$MODEFILE" 2>/dev/null || echo "random")"
              if [ "$prev" = "random" ]; then startmode="ordered"; else startmode="random"; fi
            else
              startmode="random"
            fi
            if [ -x "$SCRIPT" ]; then
              nohup "$SCRIPT" "$WALLPAPER_DIR" "$INTERVAL" "$startmode" >/dev/null 2>&1 &
              sleep 0.3
              if hyprpapercyclectl status >/dev/null 2>&1 && hyprpapercyclectl status 2>&1 | grep -qi running; then
                ironbar_do_on; notify_on
                ${notify-send} -a hyprpaper -t 2000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Started wallpaper cycle mode=$startmode"
                exit 0
              else
                echo "Failed to start hyprpapercycle via $SCRIPT" >&2; exit 1
              fi
            else
              echo "hyprpapercycle binary not found at $SCRIPT" >&2; exit 2
            fi
          fi
        ;;
        next)
          hyprpapercyclectl next
          exit $?
        ;;
        prev)
          hyprpapercyclectl prev
          exit $?
        ;;
        *)
          echo "usage: $0 [toggle|next|prev]" >&2
          exit 2
        ;;
      esac
    fi

    # If hyprpapercyclectl missing, operate on pidfile/fifo directly
    if [ -e "$PIDFILE" ]; then
      pid=$(cat "$PIDFILE" 2>/dev/null || echo "")
      if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        case "$ACTION" in
          toggle)
            # prefer fifo
            if [ -p "$CMDFIFO" ]; then
              printf 'toggle\n' > "$CMDFIFO" 2>/dev/null
              newmode="$(cat "$MODEFILE" 2>/dev/null || echo "unknown")"
              ${notify-send} -a hyprpaper -t 2000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Toggled wallpaper mode -> $newmode"
              exit 0
            fi
            kill -USR1 "$pid"
            ${notify-send} -a hyprpaper -t 2000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Toggled wallpaper mode (signal)"
            exit 0
          ;;
          next)
            if [ -p "$CMDFIFO" ]; then
              printf 'next\n' > "$CMDFIFO" 2>/dev/null
              ${notify-send} -a hyprpaper -t 1000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Next wallpaper"
              exit 0
            fi
            # fallback: try SIGUSR2 for systems that still support it
            kill -USR2 "$pid"
            ${notify-send} -a hyprpaper -t 1000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Next wallpaper (signal)"
            exit 0
          ;;
          prev)
            if [ -p "$CMDFIFO" ]; then
              printf 'prev\n' > "$CMDFIFO" 2>/dev/null
              ${notify-send} -a hyprpaper -t 1000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Previous wallpaper"
              exit 0
            fi
            echo "prev not supported without hyprpapercyclectl or FIFO" >&2
            exit 1
          ;;
        esac
      else
        rm -f "$PIDFILE" 2>/dev/null || true
      fi
    fi

    # not running: start with opposite mode for toggle, or report for next/prev
    if [ "$ACTION" = "toggle" ]; then
      if [ -f "$MODEFILE" ]; then
        prev="$(cat "$MODEFILE" 2>/dev/null || echo "random")"
        if [ "$prev" = "random" ]; then startmode="ordered"; else startmode="random"; fi
      else
        startmode="random"
      fi
      if [ -x "$SCRIPT" ]; then
        nohup "$SCRIPT" "$WALLPAPER_DIR" "$INTERVAL" "$startmode" >/dev/null 2>&1 &
        sleep 0.3
        if [ -e "$PIDFILE" ]; then
          ironbar_do_on; notify_on
          ${notify-send} -a hyprpaper -t 2000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Started wallpaper cycle mode=$startmode"
          exit 0
        fi
        echo "Started hyprpapercycle but pidfile missing" >&2
        ironbar_do_on; notify_on
        ${notify-send} -a hyprpaper -t 2000 -i preferences-desktop-wallpaper-symbolic "hyprpapercycle" "Started wallpaper cycle mode=$startmode (no pidfile)"
        exit 0
      else
        echo "hyprpapercycle binary not found at $SCRIPT" >&2
        exit 3
      fi
    else
      echo "not-running" >&2
      exit 3
    fi
  ''
