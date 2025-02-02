#!/usr/bin/env bash

screenshot() {
  grim -o $1 -l 0 "/tmp/hyprlock_screenshot_$1.png" # run this command in background
}
hyprctl monitors | grep "Monitor" | awk '{printf "%s\n", $2}' | while read -r line; do screenshot "$line"; done &
wait && # wait background commands to finish
pidof hyprlock || hyprlock # so hyprlock will only start when screenshot(s) are done
