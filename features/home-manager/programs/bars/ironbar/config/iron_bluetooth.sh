#!/usr/bin/env bash

get_device_icon() {
  local device_info=$(bluetoothctl info "$1" 2>/dev/null)
  echo "$device_info" | grep 'Icon:' | awk -F': ' '{print $2}'
}

get_device_name() {
  local device_info=$(bluetoothctl info "$1" 2>/dev/null)
  echo "$device_info" | grep 'Name:' | awk -F': ' '{print $2}'
}

BLU_CNT_CONTROLLER=$(ls -1q /sys/class/bluetooth | wc -l)

if [[ $BLU_CNT_CONTROLLER -gt 0 ]] then
  BLU_POWER=$(bluetoothctl show | grep -q 'Powered: yes$'; echo "$?")
  if [[ $BLU_POWER -eq 0 ]] then
    devices=$(bluetoothctl devices Connected | awk '{print $2}')
  fi
else
  $(ironbar var set show_bluetooth 0) # Using $() so "ok" isn't outputted
fi

if [[ $1 == "button" ]] then
  if [[ $BLU_POWER -eq 0 ]] then
    if [[ $devices != "" ]] then
      echo "" #"󰂱"
    else
      echo "󰂯"
    fi
  else
    echo "󰂲"
  fi
else
  if [[ $1 == "popup" ]] then
    if [[ $devices != "" ]] then
      for device in $devices; do
        icon=$(get_device_icon "$device")
        name=$(get_device_name "$device")
        [ $icon == "input-keyboard" ] && icon=""
        [ $icon == "input-mouse" ] && icon=""
        [ $icon == "audio-headset" ] && icon=""
        [ $icon == "audio-card" ] && icon="󱀞"
        [ $icon == "computer" ] && icon=""
        [ $icon == "phone" ] && icon=""
        [ $icon == "media" ] && icon=""
        [ $icon == "network" ] && icon=""
        [ $icon == "printer" ] && icon="󰐪"
        [ $icon == "camera" ] && icon=""
        [ $icon == "gamepad" ] && icon="󰖺"
        printf "%s  %s" "$icon" "$name"
      done
    fi
  fi
fi
