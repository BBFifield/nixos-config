{config, ...}: ''
  $network_popup = {
    type = "custom"
    name = "network"
    bar = [
      {
        type = "button"
        label = "{{watch:bash ${./network.sh}}}"
        on_click = "popup:toggle"
      }
    ]
  }
''
