pkgs:
pkgs.writeShellScript "output_network_status" ''
  while :; do

    message=""

    # 1) Internet check
    connectivity=$(nmcli networking connectivity 2>/dev/null || echo none)
    has_internet=$([ "$connectivity" = "full" ] && echo true || echo false)

    # 2) Ethernet check
    ethernet_connected=false
    if nmcli -t -f TYPE,STATE device status | grep -q "^ethernet:connected$"; then
      ethernet_connected=true
    fi

    # 3) Wi-Fi enabled check
    wifi_enabled=$([ "$(nmcli radio wifi)" = "enabled" ] && echo true || echo false)

    # 4) Grab SSID of active Wi-Fi
    wifi_ssid=$(
      nmcli -t -f TYPE,STATE,CONNECTION d \
        | awk -F: '$1=="wifi"{print $3; exit}'
    )

    # 5) Priority-based tooltip
    if [[ $ethernet_connected == false && $wifi_enabled == false ]]; then
      message="No network adapter connected"
      echo "󰅛"
    elif [[ $ethernet_connected == true ]]; then
      if [[ $has_internet == true ]]; then
        message="Ethernet, connected to internet"
        echo "󰈁"
      else
        message="Ethernet connected, no internet"
        echo "󰈂"
      fi
    elif [[ -n $wifi_ssid && $has_internet == true ]]; then
      wifi_strength=$(
        nmcli -t -f SSID,SIGNAL device wifi list --rescan no |
        awk -F: -v ssid="$wifi_ssid" '$1 == ssid { print $2; exit }'
      )
      message="Connected to $wifi_ssid; Strength $wifi_strength"
      # choose message based on numeric ranges
      if   (( wifi_strength <  20 )); then echo "󰤯"
      elif (( wifi_strength <  40 )); then echo "󰤟"
      elif (( wifi_strength <  60 )); then echo "󰤢"
      elif (( wifi_strength <  80 )); then echo "󰤥"
      else                                 echo "󰤨"
      fi
    elif [[ -n $wifi_ssid && $has_internet == false ]]; then
      message="Connected to $wifi_ssid, no internet"
      echo "󱚵"
    else
      message="Not connected to any network"
      echo "󱛅"
    fi
    ironbar var set network_status "$message" &> /dev/null

    sleep 5s;
  done
''
