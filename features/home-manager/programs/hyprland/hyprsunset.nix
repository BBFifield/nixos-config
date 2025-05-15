{
  config,
  pkgs,
}:
pkgs.writeShellScript "hyprsunset" ''
  if [[ $(systemctl --user status hyprsunset.service | grep 'active (running)') ]]; then systemctl --user stop hyprsunset.service; ${
    if config.hm.ironbar.enable
    then "ironbar var set night_light_icon 󱩍; ironbar var set show_night_light_slider false"
    else ""
  }; else systemctl --user start hyprsunset.service; while ! hyprctl hyprsunset temperature $(ironbar var get night_light_value) 2>/dev/null; do sleep 0.01; done; ${
    if config.hm.ironbar.enable
    then "ironbar var set night_light_icon 󱩌; ironbar var set show_night_light_slider true"
    else ""
  }; fi
''
