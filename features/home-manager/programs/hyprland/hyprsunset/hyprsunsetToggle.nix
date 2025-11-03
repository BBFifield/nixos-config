{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.hyprland.hyprsunset;
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScript "hyprsunsetToggle" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # hyprsunset toggle with persistent state file
    # - ensure hyprsunset.service is started at session start but identity (off) is applied
    # - maintain a small state file in XDG_RUNTIME_DIR so other tools (ironbar, status apps)
    #   can observe whether identity or a temperature is currently in effect
    #
    # State file format:
    #  - identity
    #  - temp:<NUMBER>   (e.g. temp:4000)
    #
    # The script both reads and updates that file when it changes the filter.

    ironbar_enabled=${
      if config.hm.ironbar.enable
      then "true"
      else "false"
    }

    NOTIFY="${notify-send}"
    ICON_ON="night-light-symbolic"
    ICON_OFF="night-light-disabled-symbolic"

    ironbar_toggle_icon() {
      [ "$ironbar_enabled" = "true" ] || return 0
      command -v ironbar >/dev/null 2>&1 || return 0
      ironbar var set night_light_icon "$1"
    }
    ironbar_set_slider_visibility() {
      [ "$ironbar_enabled" = "true" ] || return 0
      command -v ironbar >/dev/null 2>&1 || return 0
      ironbar var set show_night_light_slider "$1"
    }
    ironbar_set_status() {
      [ "$ironbar_enabled" = "true" ] || return 0
      command -v ironbar >/dev/null 2>&1 || return 0
      ironbar var set night_light_status "$1"
    }
    ironbar_add_class() {
      [ "$ironbar_enabled" = "true" ] || return 0
      command -v ironbar >/dev/null 2>&1 || return 0
      ironbar style add-class tools nightLightOn >/dev/null 2>&1 || true
    }
    ironbar_remove_class() {
      [ "$ironbar_enabled" = "true" ] || return 0
      command -v ironbar >/dev/null 2>&1 || return 0
      ironbar style remove-class tools nightLightOn >/dev/null 2>&1 || true
    }

    notify_on() {
      command -v "$NOTIFY" >/dev/null 2>&1 && "$NOTIFY" -a hyprsunset -t 5000 -i "$ICON_ON" 'Night Light On' 'Night light has been switched on'
    }
    notify_off() {
      command -v "$NOTIFY" >/dev/null 2>&1 && "$NOTIFY" -a hyprsunset -t 5000 -i "$ICON_OFF" 'Night Light Off' 'Night light has been switched off'
    }

    # runtime dir + state file
    export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    STATEFILE="$XDG_RUNTIME_DIR/hyprsunset.state"

    write_state_identity() {
      printf '%s\n' "identity" > "$STATEFILE" 2>/dev/null || true
    }
    write_state_temp() {
      printf 'temp:%s\n' "$1" > "$STATEFILE" 2>/dev/null || true
    }
    read_state() {
      if [ -e "$STATEFILE" ]; then
        cat "$STATEFILE" 2>/dev/null || echo "identity"
      else
        echo "identity"
      fi
    }

    # helpers: service and hyprctl waiters
    service_running() {
      systemctl --user is-active --quiet hyprsunset.service
    }

    hyprctl_wait_request() {
      # usage: hyprctl_wait_request identity
      local cmd=(hyprctl hyprsunset "$@")
      local tries=0
      local max=40
      while [ $tries -lt $max ]; do
        if "''${cmd[@]}" >/dev/null 2>&1; then
          return 0
        fi
        tries=$((tries + 1))
        sleep 0.05
      done
      return 1
    }

    # Probe hyprsunset for the last applied temperature once (used when toggling from identity -> temp)
    probe_hyprctl_temp_once() {
      # hyprctl hyprsunset temperature prints a value (or an error). Extract first 3-5 digit number.
      out="$(hyprctl hyprsunset temperature 2>/dev/null || true)"
      printf '%s\n' "$out" | grep -Eo '[0-9]{3,5}' | head -n1 || true
    }

    # ensure the service is started at session login but left inactive (identity)
    # This path can be used by your session autostart to ensure hyprsunset is present.
    ensure_service_started_identity() {
      # start the service (no-op if already started)
      systemctl --user start hyprsunset.service

      # set identity to ensure no filter applied
      if hyprctl_wait_request identity; then
        write_state_identity
        ironbar_toggle_icon "󱩍"
        ironbar_set_slider_visibility "false"
        ironbar_set_status "OFF"
        ironbar_remove_class
      else
        # best-effort: still record identity if hyprctl didn't respond yet
        write_state_identity
      fi
    }

    # Main toggle behavior:
    # - If service is active AND current state file says temp:<n> (i.e. bluelight is applied) ->
    #     set identity, update state to identity, notify/ironbar, leave service running (so the daemon still exists)
    # - If service is active AND current state is identity -> apply last known temperature from hyprsunset (probe) or fallback to cfg.initTemp
    # - If service inactive -> start service and ensure identity, then apply temperature if requested

    # Read current observed state
    CUR_STATE="$(read_state)"

    # Determine whether hyprsunset service is active; if not, start it but keep identity
    if ! service_running; then
      # start service but keep identity applied
      ensure_service_started_identity
      # after ensuring service + identity, set CUR_STATE to identity
      CUR_STATE="identity"
    fi

    # If current state indicates temperature is applied -> switch to identity (turn off)
    case "$CUR_STATE" in
      temp:*)
        # turn off (identity) but keep service running so subsequent toggles can reapply temperature quickly
        if hyprctl_wait_request identity; then
          write_state_identity
          ironbar_toggle_icon "󱩍"
          ironbar_set_slider_visibility "false"
          ironbar_set_status "OFF"
          ironbar_remove_class
          notify_off
          exit 0
        else
          echo "Failed to apply identity via hyprctl" >&2
          exit 1
        fi
        ;;

      identity)
        # Try to retrieve the last used temperature from hyprsunset itself
        probed="$(probe_hyprctl_temp_once)"
        if [ -n "$probed" ]; then
          temp="$probed"
        else
          temp=${cfg.initTemp}
        fi

        if hyprctl_wait_request temperature "$temp"; then
          write_state_temp "$temp"
          ironbar_toggle_icon "󱩌"
          ironbar_set_slider_visibility "true"
          ironbar_set_status "ON"
          ironbar_add_class
          notify_on
          exit 0
        else
          echo "Failed to apply temperature $temp via hyprctl" >&2
          exit 1
        fi
        ;;

      *)
        # unknown state file contents; reset to identity and continue
        write_state_identity
        echo "Unknown state; resetting to identity" >&2
        exit 1
        ;;
    esac
  ''
