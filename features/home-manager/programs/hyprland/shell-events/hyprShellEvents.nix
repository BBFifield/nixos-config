{
  config,
  pkgs,
}: let
  colorStr = config.wayland.windowManager.hyprland.settings.general."col.active_border";
  colorStrEscaped = builtins.replaceStrings ["$"] ["\\$"] colorStr;
  wallpaperService =
    if (config.hm.wallpaper.daemon == "wpaperd")
    then "wpaperd.service"
    else "";
in
  pkgs.writeShellApplication {
    name = "hyprshellevents";
    runtimeInputs = with pkgs; [openssl];
    text = ''
      PREV_WINDOWADDRESS=""

      last_event_ts=0

      event_activewindowv2() {
        ts=$(date +%s%3N)
        ACTIVE_COLOR="${colorStrEscaped}"
        FLASH_COLOR="\$base0D \$base00 \$base08 \$base00 30deg"
        FLASH_MS=500
        DEBOUNCE_MS=565      # ignore extremely rapid focus flips

        set_border_color() {
          hyprctl --quiet keyword general:col.active_border "$1"
        }

        if (( ts - last_event_ts < DEBOUNCE_MS )); then
          return
        fi
        if [ "$WINDOWADDRESS" != "$PREV_WINDOWADDRESS" ]; then
          PREV_WINDOWADDRESS=$WINDOWADDRESS
        fi
        # set flash color immediately
        set_border_color "$FLASH_COLOR"

        # restore after FLASH_MS
        sleep_time=$(awk "BEGIN {print $FLASH_MS/1000}")
        sleep "$sleep_time"
        set_border_color "$ACTIVE_COLOR"
        last_event_ts=$ts
      }

      event_monitoradded() {
        systemctl --user restart ${wallpaperService} ironbar.service
      }
    '';
  }
