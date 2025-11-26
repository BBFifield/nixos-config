{
  config,
  pkgs,
}:
pkgs.writeShellApplication {
  name = "gamemode";
  runtimeInputs = with pkgs; [libnotify];
  text = ''
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

    ironbar_enabled=${
      if config.hm.ironbar.enable
      then "true"
      else "false"
    }

    ironbar_set_status() {
      if command -v ironbar >/dev/null 2>&1; then
        ironbar var set gamemode_status "$1"
      fi
    }
    ironbar_toggle_icon_class() {
      if command -v ironbar >/dev/null 2>&1; then
        ironbar style toggle-class tools gamemodeOff
      fi
    }

    ironbar_do_off() {
      [ "$ironbar_enabled" = "true" ] || return 0
      ironbar_set_status '[OFF]'
      ironbar_toggle_icon_class
    }
    ironbar_do_on() {
      [ "$ironbar_enabled" = "true" ] || return 0
      ironbar_set_status '[ON]'
      ironbar_toggle_icon_class
    }

    if [ "$HYPRGAMEMODE" = 1 ] ; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword animation borderangle,0; \
            keyword decoration:shadow:enabled 0;\
            keyword decoration:blur:enabled 0;\
            keyword decoration:fullscreen_opacity 1;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
        notify-send -a hyprland -e -t 5000 -i "applications-games-symbolic" "Gamemode [ON]" 'Gamemode has been switched on'
        ironbar_do_on
        exit
    else
        notify-send -a hyprland -e -t 5000 -i "applications-games-symbolic" "Gamemode [OFF]" 'Gamemode has been switched off'
        ironbar_do_off
        hyprctl reload
        exit 0
    fi
  '';
}
