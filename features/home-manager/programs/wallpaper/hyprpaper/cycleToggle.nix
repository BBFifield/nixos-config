{
  config,
  pkgs,
}: let
  hyprpaperCycle = "${(import ./cycle.nix {inherit config pkgs;})}/bin/hyprpapercycle";
  wallpaperDir = "${config.home.homeDirectory}/Pictures/wallpapers";
  interval = builtins.toString config.hm.wallpaper.interval;

  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScript "hyprpapercycletoggle" ''
    set -euo pipefail

    # Toggle hyprpapercycle status
    # - Prefer hyprpapercyclectl when available (queries PID in XDG_RUNTIME_DIR)
    # - Otherwise start/stop hyprpapercycle directly
    # Ironbar integration and notifications are conditional on config.hm.ironbar.enable

    MODEFILE="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hyprpapercycle.mode"
    cur="$(cat "$MODEFILE" 2>/dev/null || echo "random")"

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
        ironbar style toggle-class tools wallpaperCycleOff
      fi
    }
    notify_off() {
        ${notify-send} -a hyprpaper -e -t 5000 -i preferences-desktop-wallpaper-symbolic 'Wallpaper Cycle [OFF]'
    }
    notify_on() {
        ${notify-send} -a hyprpaper -e -t 5000 -i preferences-desktop-wallpaper-symbolic 'Wallpaper Cycle [ON]' "Sort method: $cur"
    }

    # Combined helpers (call these)
    ironbar_do_off() {
      [ "$ironbar_enabled" = "true" ] || return 0
      ironbar_set_status 'Wallpaper Cycle [OFF]'
      ironbar_toggle_icon_class
    }
    ironbar_do_on() {
      [ "$ironbar_enabled" = "true" ] || return 0
      ironbar_set_status 'Wallpaper Cycle [ON]'
      ironbar_toggle_icon_class
    }

    SCRIPT="${hyprpaperCycle}"
    WALLPAPER_DIR="${wallpaperDir}"
    INTERVAL="${interval}"

    # Prefer hyprpapercyclectl when present
    if command -v hyprpapercyclectl >/dev/null 2>&1; then
      if hyprpapercyclectl status >/dev/null 2>&1 && hyprpapercyclectl status 2>&1 | grep -qi running; then
        # running -> stop
        hyprpapercyclectl stop
        ironbar_do_off
        notify_off
        exit 0
      else
        # not running -> start
        if [ -x "$SCRIPT" ]; then
          nohup "$SCRIPT" "$INTERVAL" "$cur" >/dev/null 2>&1 &
          sleep 0.3
          if hyprpapercyclectl status >/dev/null 2>&1 && hyprpapercyclectl status 2>&1 | grep -qi running; then
            ironbar_do_on
            notify_on
            exit 0
          else
            echo "Failed to start hyprpapercycle via $SCRIPT" >&2
            exit 1
          fi
        else
          echo "Binary not found at $SCRIPT" >&2
          exit 2
        fi
      fi
    fi

    # If hyprpapercyclectl missing, manage hyprpapercycle via PID file
    PIDFILE="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hyprpapercycle.pid"

    if [ -e "$PIDFILE" ]; then
      pid=$(cat "$PIDFILE" 2>/dev/null || echo "")
      if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
        ironbar_do_off
        notify_off
        # remove pidfile; hyprpapercycle should also remove on exit
        rm -f "$PIDFILE" 2>/dev/null || true
        exit 0
      else
        # stale pidfile: remove and start
        rm -f "$PIDFILE" 2>/dev/null || true
      fi
    fi

    # Start hyprpapercycle directly
    if [ -x "$SCRIPT" ]; then
      nohup "$SCRIPT" "$INTERVAL" "$cur" >/dev/null 2>&1 &
      sleep 0.3
      # check pidfile or background process
      if [ -e "$PIDFILE" ]; then
        ironbar_do_on
        notify_on
        exit 0
      else
        # best-effort: check background PID
        echo "Started hyprpapercycle but pidfile missing" >&2
        ironbar_do_on
        notify_on
        exit 0
      fi
    else
      echo "hyprpapercycle binary not found at $SCRIPT" >&2
      exit 3
    fi
  ''
