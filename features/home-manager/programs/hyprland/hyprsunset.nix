{
  config,
  pkgs,
}:
pkgs.writeShellScript "hyprsunset" ''
  if [[ $(systemctl --user status hyprsunset.service | grep 'active (running)') ]]; then systemctl --user stop hyprsunset.service; ${
    if config.hm.ironbar.enable
    then "ironbar var set night_light_icon 󱩍; ironbar var set show_night_light_slider false; notify-send -a hyprsunset -t 5000 -i preferences-desktop-wallpaper-symbolic 'Night Light Off' 'Night light has been switched off'"
    else ""
  }; else systemctl --user start hyprsunset.service; while ! hyprctl hyprsunset temperature $(ironbar var get night_light_value) 2>/dev/null; do sleep 0.01; done; ${
    if config.hm.ironbar.enable
    then "ironbar var set night_light_icon 󱩌; ironbar var set show_night_light_slider true; notify-send -a hyprsunset -t 5000 -i preferences-desktop-wallpaper-symbolic 'Night Light On' 'Night light has been switched on'"
    else ""
  }; fi
''
