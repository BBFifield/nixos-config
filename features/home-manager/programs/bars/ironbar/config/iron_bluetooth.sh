#!/usr/bin/env bash
BLU_CNT_CONTROLLER=$(ls -1q /sys/class/bluetooth | wc -l)

if [[ $BLU_CNT_CONTROLLER -gt 0 ]] then
  BLU_POWER=$(bluetoothctl show | grep -q 'Powered: yes$'; echo "$?")
  if [[ $BLU_POWER -eq 0 ]] then
    BLU_CONNECTED=$(bluetoothctl devices Connected)
  fi
else
  $(ironbar var set show_bluetooth 0) # Using $() so "ok" isn't outputted
fi

if [[ $1 == "button" ]] then
  if [[ $BLU_POWER -eq 0 ]] then
    if [[ $BLU_CONNECTED != "" ]] then
      echo "󰂱"
    else
      echo "󰂯"
    fi
  else
    echo "󰂲"
  fi
else
  if [[ $1 == "popup" ]] then 
    if [[ $BLU_CONNECTED != "" ]] then
      echo $(echo $BLU_CONNECTED | sed -n -e 's/^Device \(.*\)/\1/p')
    fi
  fi
fi
