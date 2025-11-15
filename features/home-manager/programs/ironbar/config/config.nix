{
  config,
  pkgs,
  lib,
}: let
  cfg = config.hm.ironbar;
  isEnabled = module: output:
    if (builtins.elem module cfg.customModules)
    then output
    else "";
in ''
  let {
    ${lib.concatStrings (map (module: import ./customModules/${module} {inherit config lib pkgs;}) cfg.customModules)}
    $workspaces = {
      type = "workspaces"
      class = "linked"
      all_monitors = false
      favorites = [ "1" "2" "3" "4" "5" ]
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
      show_if = "systemctl --user is-active --quiet swaync.service"
    }

    $clock = { type = "clock" format = "<span font-size='13pt'></span> %d-%h-%Y <span font-size='16pt' font-family='DS-Digital'>%I:%M%P</span>" }
    $tray = { type = "tray" icon_size = 32 ${isEnabled "tray-revealer" ''show_if = "#show_tray"''} }

    $bluetooth = {
      type = "bluetooth"
      icon_size = 32
      format.not_found = ""
      format.disabled = "󰂲"
      format.enabled = ""
      format.connected = ""
      format.connected_battery = ""
      popup.scrollable = true
      popup.header = " Enable Bluetooth"
      popup.disabled = "{adapter_status}"
      popup.device.header = "{device_alias}"
      popup.device.header_battery = "{device_alias}"
      popup.device.footer = "{device_status}"
      popup.device.footer_battery = "{device_status} • Battery {device_battery_percent}%"
      adapter_status.not_found = "No Bluetooth adapters found"
      adapter_status.enabled = "Bluetooth enabled"
      adapter_status.enabling = "Enabling Bluetooth..."
      adapter_status.disabled = "Bluetooth disabled"
      adapter_status.disabling = "Disabling Bluetooth..."
      device_status.connected = "Connected"
      device_status.connecting = "Connecting..."
      device_status.disconnected = "Disconnect"
      device_status.disconnecting = "Disconnecting..."
    }

    $clipboard = {
      type = "clipboard"
      icon = ""
      max_items = 6
      truncate.Map = 50
      truncate.mode = "end"
      truncate.length = 50
      truncate.max_length = 50
      on_click_right = "!wl-copy -c"
    }

    $volume = {
      type = "volume"
      format = "{icon}"
      max_volume = 100
      icons.volume_high = ""
      icons.volume_medium = ""
      icons.volume_low = ""
      icons.muted = ""
      on_click_right = "pwvucontrol"
      on_scroll_up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      on_scroll_down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    }

    $bindmode = {
      type = "bindmode"
      truncate = "start"
    }

    $music = {
      type = "music"
      player_type = "mpris"
      format = "{title} / {artist}"
      truncate.mode = "end"
      truncate.max_length = 20
      icons.play = ""
      icons.pause = ""
      music_dir = "${config.home.homeDirectory}/Music"
    }

    $left = [ ${isEnabled "walker" "$walker_popup"} $bindmode $workspaces ]
    $center = [ $clock $notifications ]
    $right = [ ${isEnabled "tray-revealer" "$tray_revealer"} $tray ${isEnabled "tools" "$tools_popup"} ${isEnabled "stats" "$stats_popup"} ${isEnabled "network" "$network_popup"} $bluetooth $clipboard $volume ${isEnabled "power" "$power_popup"} ]
  }

  in {
    name = "topbar"
    height = 30
    anchor_to_edges = true
    position = "top"
    popup_gap = 10
    icon_theme = "${config.hm.theme.iconTheme}"

    ironvar_defaults = {
      show_tray = "false"
      tray_icon = ""
      night_light_icon = "󱩍"
      night_light_status = "OFF"
      show_night_light_slider = "false"
      is_wallpaper_cycle_on = "${
    if (config.hm.wallpaper.cycle)
    then "true"
    else "false"
  }"
      wallpaper_cycle_status = "Wallpaper cycle ${
    if (config.hm.wallpaper.cycle)
    then "ON"
    else "OFF"
  }"
      network_status = "Not connected to internet"
      cpu_stats = "default"
      ram_stats = "default"
      disk_stats = "default"
      gpu_stats = "default"
      uptime_stats = "default"
      show_system_info = "false"
      sys_info_btn_label = " System Info"
      cpu_info = "default"
      root_partition_info = "default"
      gpu_info = "default"
      show_theme_info = "false"
      theme_info_btn_label = " Theme Info"
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
      wallpaper_name = "default"
    }

    start = $left
    center = $center
    end = $right
  }
''
