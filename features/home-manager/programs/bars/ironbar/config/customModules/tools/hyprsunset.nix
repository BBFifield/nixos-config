config: ''if [[ $(systemctl --user status hyprsunset.service | grep 'active (running)') ]]; then systemctl --user stop hyprsunset.service; ${
    if config.hm.ironbar.enable
    then "ironbar var set night_light_icon 󱩍"
    else ""
  }; else systemctl --user start hyprsunset.service; while ! hyprctl hyprsunset temperature 3000 2>/dev/null; do sleep 0.01; done; ${
    if config.hm.ironbar.enable
    then "ironbar var set night_light_icon 󱩌"
    else ""
  }; fi''
