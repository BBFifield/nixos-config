{
  config,
  pkgs,
}: let
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScript "wallpapercycletoggle" ''
    set -euo pipefail

    # Toggle wpaperd via wpaperctl (assumes wpaperctl is available)
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

    ironbar_toggle_icon_class() {
      if command -v ironbar >/dev/null 2>&1; then
        ironbar style toggle-class tools wallpaperCycleOn
      fi
    }

    notify_off() {
      ${notify-send} -a wpaperd -e -t 5000 -i preferences-desktop-wallpaper-symbolic 'Wallpaper Cycle [OFF]' ""
    }
    notify_on() {
      ${notify-send} -a wpaperd -e -t 5000 -i preferences-desktop-wallpaper-symbolic 'Wallpaper Cycle [ON]' 'Sort method: random'
    }

    ironbar_do_off() {
      [ "$ironbar_enabled" = "true" ] || return 0
      ironbar_set_status 'Wallpaper Cycle [OFF]' 'false'
      ironbar_toggle_icon_class
    }
    ironbar_do_on() {
      [ "$ironbar_enabled" = "true" ] || return 0
      ironbar_set_status 'Wallpaper Cycle [ON]' 'true'
      ironbar_toggle_icon_class
    }

    # Ensure runtime dir is consistent for control tools
    export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

    # The control command we call (assume available in PATH)
    WPAPERCTL_CMD="wpaperctl"

    # Helper: return success if wpaperctl reports running
    wpaperctl_running() {
      "$WPAPERCTL_CMD" get-status >/dev/null 2>&1 || return 1
      "$WPAPERCTL_CMD" get-status 2>/dev/null | grep -qi running
    }

    # Main logic (use wpaperctl exclusively)
    if wpaperctl_running; then
      # If running -> toggle-pause (preferred)
      "$WPAPERCTL_CMD" toggle-pause 2>/dev/null || true
      ironbar_do_off
      notify_off
      exit 0
    else
      # Not running -> try resume first
      "$WPAPERCTL_CMD" resume-wallpaper 2>/dev/null || true

      # Poll for running status briefly
      tries=0
      until [ $tries -ge 8 ]; do
        sleep 0.25
        if wpaperctl_running; then
          ironbar_do_on
          notify_on
          exit 0
        fi
        tries=$((tries + 1))
      done

      # If resume didn't work, try to start the daemon via wpaperctl's expected start path
      # Some deployments expect the daemon to be started externally; we try a best-effort:
      if command -v wpaperd >/dev/null 2>&1; then
        # start wpaperd in background with default config (assumes it will register with wpaperctl)
        nohup wpaperd --daemon >/dev/null 2>&1 &
        # poll again
        tries=0
        until [ $tries -ge 12 ]; do
          sleep 0.25
          if wpaperctl_running; then
            ironbar_do_on
            notify_on
            exit 0
          fi
          tries=$((tries + 1))
        done
      fi

      echo "Failed to start or resume wpaperd (wpaperctl did not report running)" >&2
      exit 1
    fi
  ''
