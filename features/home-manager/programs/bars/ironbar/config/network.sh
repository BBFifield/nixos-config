#!/usr/bin/env bash

while :; do
  ifconfig_output=$(ifconfig)
  is_ethernet_up=$(echo "$ifconfig_output" | grep "enp9s0" | grep -q "<UP"; echo "$?")
  is_wifi_up=$(echo "$ifconfig_output" | grep "wlp2s0" | grep -q "<UP"; echo "$?")
  if [[ $is_ethernet_up -eq 0 ]]; then
    echo "󰈀"
  else
    if [[ $is_wifi_up -eq 0 ]]; then
      echo "󰖩"
    else
      echo "󰅛"
    fi
  fi
  sleep 5s
done
