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
            on_click = "!${(import ./hyprsunset.nix) config}"
            tooltip = "Night Light"
          }
        ]
      }
    ]
  }
''
