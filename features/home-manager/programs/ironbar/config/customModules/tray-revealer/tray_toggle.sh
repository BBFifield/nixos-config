#!/usr/bin/env bash

tray_status=$(ironbar var get show_tray)
if [[ $tray_status == "false" ]]; then
    ironbar var set show_tray "true" >/dev/null 2>&1 || true
    ironbar var set tray_icon "" >/dev/null 2>&1 || true
else
    ironbar var set show_tray "false" >/dev/null 2>&1 || true
    ironbar var set tray_icon "" >/dev/null 2>&1 || true
fi
