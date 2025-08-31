{config, ...}: ''
  $walker_popup = {
    type = "custom"
    name = "walker"
    bar = [
      {
        type = "button"
        label = ""
        name = "walker-btn"
        on_click = "!hyprctl keyword windowrulev2 move 20 53, class:'^(dev.benz.walker)$' && walker && sleep 1s && hyprctl keyword windowrulev2 center, class:'^(dev.benz.walker)$'"

      }
    ]
  }
''
