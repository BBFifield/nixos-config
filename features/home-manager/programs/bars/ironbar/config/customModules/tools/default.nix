config: ''
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
        orientation = "horizontal"
        widgets = [
          {
            type = "button"
            name = "colorPicker"
            class = "tool"
            label = "󰌁"
            on_click = "!bash ${./update_picked_color.sh}"
            tooltip = "#picked_color"
          }
          {
            type = "button"
            name = "blueLightFilter"
            class = "tool"
            label = "#night_light_icon"
            on_click = "!if [[ $(systemctl --user status hyprsunset.service) ]]; then systemctl --user stop hyprsunset.service; ironbar var set night_light_icon 󱩍; else uwsm app -t service -u hyprsunset.service -- hyprsunset -t 3000; ironbar var set night_light_icon 󱩌; fi"
            tooltip = "Night Light"
          }
        ]
      }
    ]
  }
''
