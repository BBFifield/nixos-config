config: lib: let
  cfg = config.hm.ironbar;
  isEnabled = module: output:
    if (builtins.elem module cfg.customModules)
    then output
    else "";
in ''
  let {
    ${lib.concatStrings (map (module: import ./customModules/${module} config) cfg.customModules)}
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

    $clock = { type = "clock" format = " %d-%h-%Y-%I:%M%P" }
    $tray = { type = "tray" icon_size = 32 }

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
      on_scroll_up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      on_scroll_down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    }


    $left = [ ${isEnabled "walker" "$walker_popup"} $workspaces ]
    $center = [ $clock $notifications ]
    $right = [ $tray ${isEnabled "tools" "$tools_popup"} ${isEnabled "stats" "$stats_popup"} ${isEnabled "network" "$network_popup"} ${isEnabled "bluetooth" "$bluetooth_popup"} $clipboard $volume ${isEnabled "power" "$power_popup"} ]
  }

  in {
    name = "topbar"
    height = 30
    anchor_to_edges = true
    position = "top"
    popup_gap = -10
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
      night_light_icon = "󱩍"
    }

    start = $left
    center = $center
    end = $right
  }
''
