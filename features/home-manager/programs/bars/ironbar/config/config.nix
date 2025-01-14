{config}: {
  ironbarConfig = ''
    let {
      $walker_popup = {
        type = "custom"
        name = "walker"
        bar = [
          {
            type = "button"
            name = "walker-btn"
            on_click = "!hyprctl keyword windowrulev2 move 20 58, class:'^(dev.benz.walker)$' && walker && sleep 1s && hyprctl keyword windowrulev2 center, class:'^(dev.benz.walker)$'"
            widgets = [
              {
                type = "image"
                name = "walker-img"
                src = "nix-snowflake-white"
                size = 20
              }
            ]
          }
        ]
      }

      $workspaces = {
        type = "workspaces"
        all_monitors = false
        name_map = {
          1 = " "
          2 = "󰖟"
          3 = ""
        }
        favorites = [ "1" "2" "3" ]
      }
      $config_dir = ".config/ironbar"

      $focused = { type = "focused" }

      $launcher = {
        type = "launcher"
        show_names = false
        show_icons = true
      }

      $mpris = {
        type = "music"
        player_type = "mpris"

        on_click_middle = "playerctl play-pause"
        on_scroll_up = "playerctl volume +5"
        on_scroll_down = "playerctl volume -5"
      }

      $notifications = {
        type = "notifications"
        show_count = true

        icons.closed_none = "󰍥"
        icons.closed_some = "󱥂"
        icons.closed_dnd = "󱅯"
        icons.open_none = "󰍡"
        icons.open_some = "󱥁"
        icons.open_dnd = "󱅮"
      }

      $stats_module = {
        type = "box"
        orientation = "vertical"
        widgets = [
          {
            type = "label"
            class = "header"
            label = "<span  size='medium' weight='ultrabold'>Live Stats</span>"
          }
          {
            type = "box"
            orientation = "horizontal"
            widgets = [
              {
                type = "label"
                name = "cpu-label"
                label = "  #cpu_stats"
                tooltip = "#cpu_info"
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            widgets = [
              {
                type = "label"
                name = "ram-label"
                label = "  #ram_stats"
                tooltip = "RAM"
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            widgets = [
              {
                type = "label"
                name = "disk-label"
                label = "󰉉  #disk_stats"
                tooltip = "#root_partition_info"
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            widgets = [
              {
                type = "label"
                name = "gpu-label"
                label = "󰾲  #gpu_stats"
                tooltip = "#gpu_info"
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            widgets = [
              {
                type = "label"
                name = "uptime-label"
                label = "  #uptime_stats"
                tooltip = "Uptime"
              }
            ]
          }
        ]
      }

      $theme_info_module = {
        type = "box"
        orientation = "vertical"
        widgets = [
          {
            type = "button"
            class = "reveal-btn"
            label = "<span  size='medium' weight='bold'>#theme_info_btn_label</span>"
            on_click = "![[ \"$(ironbar var get show_theme_info)\" == \"false\" ]] && (ironbar var set show_theme_info true; ironbar var set theme_info_btn_label \"Hide Theme Info\") || (ironbar var set show_theme_info false; ironbar var set theme_info_btn_label \"Show Theme Info\") &> /dev/null"
          }
          {
            type = "box"
            orientation = "horizontal"
            class = "info"
            show_if = "#show_theme_info"
            widgets = [
              {
                type = "label"
                name = "colors-label"
                label = "  "
                tooltip = "Color Scheme"
              }
              {
                type = "label"
                label = "#color_scheme"
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            show_if = "#show_theme_info"
            widgets = [
              {
                type = "label"
                name = "base00"
                label = " "
                tooltip = "#base00"
              }
              {
                type = "label"
                name = "base01"
                label = " "
                tooltip = "#base01"
              }
              {
                type = "label"
                name = "base02"
                label = " "
                tooltip = "#base02"
              }
              {
                type = "label"
                name = "base03"
                label = " "
                tooltip = "#base03"
              }
              {
                type = "label"
                name = "base04"
                label = " "
                tooltip = "#base04"
              }
              {
                type = "label"
                name = "base05"
                label = " "
                tooltip = "#base05"
              }
              {
                type = "label"
                name = "base06"
                label = " "
                tooltip = "#base06"
              }
              {
                type = "label"
                name = "base07"
                label = " "
                tooltip = "#base07"
              }
              {
                type = "label"
                name = "base08"
                label = " "
                tooltip = "#base08"
              }
              {
                type = "label"
                name = "base09"
                label = " "
                tooltip = "#base09"
              }
              {
                type = "label"
                name = "base0A"
                label = " "
                tooltip = "#base0A"
              }
              {
                type = "label"
                name = "base0B"
                label = " "
                tooltip = "#base0B"
              }
              {
                type = "label"
                name = "base0C"
                label = " "
                tooltip = "#base0C"
              }
              {
                type = "label"
                name = "base0D"
                label = " "
                tooltip = "#base0D"
              }
              {
                type = "label"
                name = "base0E"
                label = " "
                tooltip = "#base0E"
              }
              {
                type = "label"
                name = "base0F"
                label = " "
                tooltip = "#base0F"
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            show_if = "#show_theme_info"
            widgets = [
              {
                type = "label"
                name = "font-label"
                label = "  "
                tooltip = "Default Font"
              }
              {
                type = "label"
                label = "{{poll:600000:fc-match 'Monospace' | awk -F\\\" '{print $2}'}}"
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            show_if = "#show_theme_info"
            widgets = [
              {
                type = "label"
                class = "gtk-label"
                label = "  "
                tooltip = "GTK3 Theme"
              }
              {
                type = "label"
                label = "{{poll:600000:cat ~/.config/gtk-3.0/settings.ini | grep 'gtk-theme-name' | cut -d '=' -f 2}}"
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            show_if = "#show_theme_info"
            widgets = [
              {
                type = "label"
                class = "gtk-label"
                label = "  "
                tooltip = "GTK Icon Theme"
              }
              {
                type = "label"
                label = "{{poll:600000:cat ~/.config/gtk-3.0/settings.ini | grep 'gtk-icon-theme-name' | cut -d '=' -f 2}}"
              }
            ]
          }
        ]
      }

      $system_info_module = {
        type = "box"
        orientation = "vertical"
        widgets = [
          {
            type = "button"
            class = "reveal-btn"
            label = "<span  size='medium' weight='bold'>#sys_info_btn_label</span>"
            on_click = "![[ \"$(ironbar var get show_system_info)\" == \"false\" ]] && (ironbar var set show_system_info true; ironbar var set sys_info_btn_label \"Hide System Info\") || (ironbar var set show_system_info false; ironbar var set sys_info_btn_label \"Show System Info\") &> /dev/null"
          }
          {
            type = "box"
            orientation = "horizontal"
            class = "info"
            show_if = "#show_system_info"
            widgets = [
              {
                type = "box"
                orientation = "vertical"
                widgets = [
                  {
                    type = "label"
                    name = "distro-label"
                    label = "  "
                    tooltip = "Distro"
                  }
                  {
                    type = "label"
                    name = "build-label"
                    label = "  "
                    tooltip = "Build ID"
                  }
                  {
                    type = "label"
                    name = "kernel-label"
                    label = "  "
                    tooltip = "Kernel Version"
                  }
                  {
                    type = "label"
                    name = "hostname-label"
                    label = "󰇅  "
                    tooltip = "Hostname"
                  }
                  {
                    type = "label"
                    name = "packages-label"
                    label = "󰏖  "
                    tooltip = "Number of Packages Installed"
                  }
                  {
                    type = "label"
                    name = "local-ip-label"
                    label = "󰩟  "
                    tooltip = "Local IP"
                  }
                  {
                    type = "label"
                    name = "public-ip-label"
                    label = "󰩠  "
                    tooltip = "Public IP"
                  }
                ]
              }
              {
                type = "script"
                class = "info-script"
                cmd = "bash /home/$(whoami)/.config/ironbar/sys_info.sh"
                mode = "poll"
                interval = 600000
              }
            ]
          }
        ]
      }

      $stats_popup_label = {
        type = "sys_info"
        interval.memory = 5
        interval.cpu = 5
        interval.temps = 5
        interval.disks = 30
        interval.networks = 2
        format = [
          "  {cpu_percent}%|{temp_c:k10temp-Tctl}°C"
          "  {memory_used}GiB({memory_percent}%)"
        ]
      }
      $stats_popup = {
        type = "custom"
        name = "stats"
        bar = [
          {
            type = "button" name = "stats-btn" on_click = "popup:toggle"
            widgets = [ $stats_popup_label ]
          }
        ]
        popup = [
          {
            type = "box"
            orientation = "vertical"
            widgets = [
              $stats_module
              $system_info_module
              $theme_info_module
            ]
          }
        ]
      }

      $clock = { type = "clock" format = " %d-%h-%Y-%I:%M%P" }
      $tray = { type = "tray" icon_size = 32 }

      $bluetooth_popup = {
        type = "custom"
        name = "bluetooth"
        show_if = "#show_bluetooth"
        bar = [
          {
            type = "button"
            label = "{{5000:bash /home/$(whoami)/.config/ironbar/bluetooth.sh button}}"
            on_click = "popup:toggle"
          }
        ]
        popup = [
          {
            type = "box"
            orientation = "vertical"
            widgets = [
              {
                type = "label"
                label = "<span weight='ultrabold'>Connected Devices: {{watch:while :; do echo $(bluetoothctl devices Connected | wc -l); sleep 5s; done}}</span>"
              }
              {
                type = "box"
                orientation = "horizontal"
                widgets = [
                  {
                    type = "script"
                    name = "bluetooth-script"
                    cmd = "bash /home/brandon/.config/ironbar/bluetooth.sh popup"
                    mode = "poll"
                    interval = 5000
                  }
                ]
              }
              {
                type = "button"
                class = "normal-btn"
                name = "bluetooth-settings-btn"
                on_click = "!alacritty -e bluetui"
                label = "Open Bluetooth Settings"
              }
            ]
          }
        ]
      }

      $clipboard = {
        type = "clipboard"
        icon = ""
        max_items = 6
        truncate.Map = 50
        truncate.mode = "end"
        truncate.length = 50
        truncate.max_length = 50
      }

      $volume = {
        type = "volume"
        format = "{icon}"
        max_volume = 100
        icons.volume_high = ""
        icons.volume_medium = ""
        icons.volume_low = ""
        icons.muted = ""
        on_scroll_up = "wpctl set-volume \"$(wpctl status | grep \"*\" | awk 'NR==1' | awk -F. '{print $1}' | awk '{print $3}')\" 5%+"
        on_scroll_down = "wpctl set-volume \"$(wpctl status | grep \"*\" | awk 'NR==1' | awk -F. '{print $1}' | awk '{print $3}')\" 5%-"
      }

      $profile_picture = "/var/lib/AccountsService/icons/{{echo $(whoami)}}"
      $power_popup = {
        type = "custom"
        name = "power"
        bar = [ { type = "button" label = "" on_click = "popup:toggle" } ]
        popup = [
          {
            type = "box"
            orientation = "vertical"
            widgets = [
              { type = "label" name = "profile-header" label = "{{echo $(whoami)}}" }
              {type = "image" name = "profile-pic" src = $profile_picture  size = 80 }
              {
                type = "box"
                name = "power-actions-box"
                widgets = [
                  { type = "button" class="power-btn" label = "<span font-size='25pt'>󰗽</span>" on_click = "!loginctl terminate-user $(whoami)" }
                  { type = "button" class="power-btn" label = "<span font-size='25pt'>󰌾</span>" on_click = "!~/.config/hypr/start_hyprlock.sh" }
                  { type = "button" class="power-btn" label = "<span font-size='25pt'>󰐥</span>" on_click = "!shutdown now" }
                  { type = "button" class="power-btn" label = "<span font-size='25pt'>󰜉</span>" on_click = "!reboot" }
                ]
              }
            ]
          }
        ]
      }

      $left = [ $walker_popup $workspaces ]
      $center = [ $clock $notifications ]
      $right = [ $tray $stats_popup $bluetooth_popup $clipboard $volume $power_popup ]
    }

    in {
      name = "topbar"
      height = 30
      anchor_to_edges = true
      position = "top"
      icon_theme = "${config.hm.theme.iconTheme}"


      ironvar_defaults = {
        cpu_stats = "default"
        ram_stats = "default"
        disk_stats = "default"
        gpu_stats = "default"
        uptime_stats = "default"
        show_system_info = "false"
        sys_info_btn_label = "Show System Info"
        cpu_info = "default"
        root_partition_info = "default"
        gpu_info = "default"
        show_theme_info = "false"
        theme_info_btn_label = "Show Theme Info"
        color_scheme = "default"
        base00 = "default"
        base01 = "default"
        base02 = "default"
        base03 = "default"
        base04 = "default"
        base05 = "default"
        base06 = "default"
        base07 = "default"
        base08 = "default"
        base09 = "default"
        base0A = "default"
        base0B = "default"
        base0C = "default"
        base0D = "default"
        base0E = "default"
        base0F = "default"
        show_bluetooth = "true"
      }

      start = $left
      center = $center
      end = $right
    }
  '';
}
