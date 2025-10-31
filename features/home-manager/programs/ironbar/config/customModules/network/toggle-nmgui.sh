#!/usr/bin/env bash

addr=$(
  hyprctl clients | awk '
    $1=="Window"    { a="0x"$2 }
    $1=="class:" && $2=="com.network.manager" { print a }
  ' | head -n1
)

if [[ -n "$addr" ]]; then
  hyprctl dispatch closewindow address:$addr
else
  hyprctl keyword windowrule move 1400 53, class:'^(com.network.manager)$'
  # Launch in the background
  nmgui &
fi

