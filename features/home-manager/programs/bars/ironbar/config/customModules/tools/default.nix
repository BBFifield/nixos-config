{
  config,
  pkgs,
}: ''
  $tools_popup = {
    type = "custom"
    name = "tools"
    bar = [
      {
        type = "button"
        label = ""
        on_click = "popup:toggle"
      }
    ]
    popup = [
      {
        type = "box"
        orientation = "vertical"
        widgets = [
          {
            type = "button"
            name = "colorPicker"
            class = "tool"
            label = "󰌁"
            on_click = "!${import ./updatePickedColor.nix pkgs}"
            tooltip = "#picked_color"
          }
          {
            type = "box"
            orientation = "horizontal"
            halign = "center"
            widgets = [
              {
                type = "button"
                name = "nightLightToggle"
                class = "tool"
                label = "#night_light_icon"
                on_click = "!${(import ./../../../../../hyprland/hyprsunset.nix) {inherit config pkgs;}}"
                tooltip = "Night Light"
              }
              {
                type = "slider"
                name = "nightLightSlider"
                show_label = false
                show_if = "#show_night_light_slider"
                length = 100
                min = 2000
                max = 8000
                on_change="!hyprctl hyprsunset temperature \"''${0%.*}\"; ironbar var set night_light_value \"''${0%.*}\";"
                value = "#night_light_value"
                tooltip = "#night_light_value"
              }
            ]
          }
          {
            type = "button"
            name = "screenshotter"
            class = "tool"
            label = "󰹑"
            on_click = "!grim -g \"$(slurp -o -c $(echo $(ironbar var get base0D) | sed 's/^....\\(......\\)/\\1/'))\" -t ppm - | satty --filename -"
            tooltip = "Take Screenshot"
          }
          {
            type = "box"
            orientation = "horizontal"
            halign = "center"
            widgets = [
              {
                type = "button"
                name = "wallpaperToggle"
                class = "tool"
                label = "󰸉"
                on_click = "!if [[ $(wpaperctl status | grep 'running') ]]; then wpaperctl pause; ironbar var set wallpaper_daemon_on 'false'; else wpaperctl resume; ironbar var set wallpaper_daemon_on 'true'; fi"
                tooltip = "Toggle Wallpaper Cycle"
              }
              {
                type = "box"
                orientation = "horizontal"
                halign = "center"
                show_if = "#wallpaper_daemon_on"
                class = "linked"
                widgets = [
                  {
                    type = "button"
                    class = "wallpaperNav"
                    name = "wallpaperPrevious"
                    label = ""
                    on_click="!wpaperctl previous;"
                    tooltip = "Previous wallpaper"
                  }
                  {
                    type = "button"
                    class = "wallpaperNav"
                    name = "wallpaperNext"
                    label = ""
                    on_click="!wpaperctl next;"
                    tooltip = "Next wallpaper"
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
''
