{
  config,
  pkgs,
  ...
}:
pkgs.writeShellScript "hyprpaper-cycle-toggle" ''
  #!/usr/bin/env bash
  set -euo pipefail

  # Toggle wprand status
  # - Prefer wprandctl when available (queries PID in XDG_RUNTIME_DIR)
  # - Otherwise start/stop wprand directly
  # Ironbar integration and notifications are conditional on config.hm.ironbar.enable

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
  ironbar_set_icon() {
    if command -v ironbar >/dev/null 2>&1; then
      ironbar var set wallpaper_cycle_icon "$1"
    fi
  }
  notify_off() {
      ${pkgs.libnotify}/bin/notify-send -a hyprpaper -t 5000 -i hyprland 'hyprpaper-cycle Off' 'Wallpaper cycle paused'
  }
  notify_on() {
      ${pkgs.libnotify}/bin/notify-send -a hyprpaper -t 5000 -i hyprland 'hyprpaper-cycle On' 'Wallpaper cycle resumed'
  }

  # Combined helpers (call these)
  ironbar_do_off() {
    [ "$ironbar_enabled" = "true" ] || return 0
    ironbar_set_status 'hyprpaper-cycle OFF'
    ironbar_set_icon '󰀣'
  }
  ironbar_do_on() {
    [ "$ironbar_enabled" = "true" ] || return 0
    ironbar_set_status 'hyprpaper-cycle ON'
    ironbar_set_icon '󰸉'
  }

  SCRIPT="${(import ../../../../../wallpaper/hyprpaper/hyprpaperCycle.nix {inherit pkgs;})}/bin/hyprpaperCycle"
  WALLPAPER_DIR="${config.home.homeDirectory}/Pictures/wallpapers"
  INTERVAL="20"

  # Prefer wprandctl when present
  if command -v wprandctl >/dev/null 2>&1; then
    if wprandctl status >/dev/null 2>&1 && wprandctl status 2>&1 | grep -qi running; then
      # running -> stop
      wprandctl stop
      ironbar_do_off
      notify_off
      exit 0
    else
      # not running -> start
      if [ -x "$SCRIPT" ]; then
        nohup "$SCRIPT" "$WALLPAPER_DIR" "$INTERVAL" >/dev/null 2>&1 &
        sleep 0.3
        if wprandctl status >/dev/null 2>&1 && wprandctl status 2>&1 | grep -qi running; then
          ironbar_do_on
          notify_on
          exit 0
        else
          echo "Failed to start wprand via $SCRIPT" >&2
          exit 1
        fi
      else
        echo "Wprand binary not found at $SCRIPT" >&2
        exit 2
      fi
    fi
  fi

  # If wprandctl missing, manage wprand via PID file
  PIDFILE="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hyprpaper-cycle.pid"

  if [ -e "$PIDFILE" ]; then
    pid=$(cat "$PIDFILE" 2>/dev/null || echo "")
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid"
      ironbar_do_off
      notify_off
      # remove pidfile; wprand should also remove on exit
      rm -f "$PIDFILE" 2>/dev/null || true
      exit 0
    else
      # stale pidfile: remove and start
      rm -f "$PIDFILE" 2>/dev/null || true
    fi
  fi

  # Start wprand directly
  if [ -x "$SCRIPT" ]; then
    nohup "$SCRIPT" "$WALLPAPER_DIR" "$INTERVAL" >/dev/null 2>&1 &
    sleep 0.3
    # check pidfile or background process
    if [ -e "$PIDFILE" ]; then
      ironbar_do_on
      notify_on
      exit 0
    else
      # best-effort: check background PID
      echo "Started hyprpaper-cycle but pidfile missing" >&2
      ironbar_do_on
      notify_on
      exit 0
    fi
  else
    echo "hyprpaper-cycle binary not found at $SCRIPT" >&2
    exit 3
  fi
''
