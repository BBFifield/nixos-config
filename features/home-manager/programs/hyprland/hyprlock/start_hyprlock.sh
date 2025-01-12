#!/usr/bin/env bash

grim -o HDMI-A-1 -l 0 /tmp/hyprlock_screenshot1.png & # run this command in background
wait && # wait background commands to finish
pidof hyprlock || hyprlock # so hyprlock will only start when screenshot(s) are done
