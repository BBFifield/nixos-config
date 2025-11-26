{config, ...}: ''
  $theme_info_module = {
    type = "box"
    orientation = "vertical"
    widgets = [
      {
        type = "button"
        class = "reveal-btn"
        label = "#theme_info_btn_label"
        on_click = "![[ \"$(ironbar var get show_theme_info)\" == \"false\" ]] && (ironbar var set show_theme_info true; ironbar var set theme_info_btn_label \" Theme Info\") || (ironbar var set show_theme_info false; ironbar var set theme_info_btn_label \" Theme Info\") &> /dev/null"
      }
      {
        type = "box"
        orientation = "vertical"
        class = "info"
        show_if = "#show_theme_info"
        widgets = [
          {
            type = "box"
            orientation = "horizontal"
            // class = "info"
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
                tooltip = "GTK Theme"
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
          {
            type = "box"
            orientation = "horizontal"
            show_if = "#show_theme_info"
            widgets = [
              {
                type = "label"
                class = "wallpaper-label"
                label = "󰸉  "
                tooltip = "Current Wallpaper"
              }
              {
                type = "label"
                label = "#wallpaper_name"
              }
            ]
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
        label = "#sys_info_btn_label"
        on_click = "![[ \"$(ironbar var get show_system_info)\" == \"false\" ]] && (ironbar var set show_system_info true; ironbar var set sys_info_btn_label \" System Info\") || (ironbar var set show_system_info false; ironbar var set sys_info_btn_label \" System Info\") &> /dev/null"
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
            cmd = "${./sys_info.sh}"
            mode = "poll"
            interval = 600000
          }
        ]
      }
    ]
  }

  $stats_module = {
    type = "box"
    orientation = "vertical"
    widgets = [
      {
        type = "label"
        class = "header"
        label = "Live Stats"
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
  $stats_popup_label = {
    type = "sys_info"
    interval.memory = 5
    interval.cpu = 5
    interval.temps = 5
    interval.disks = 30
    interval.networks = 2
    format = [
      "<span font-size='13pt'></span> {cpu_percent}%|{temp_c:k10temp-Tctl}°C"
      "<span font-size='13pt'></span> {memory_used:2}GiB({memory_percent:2}%)"
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
''
