{config, ...}: ''
  $bluetooth_popup = {
    type = "custom"
    name = "bluetooth"
    show_if = "#show_bluetooth"
    bar = [
      {
        type = "button"
        label = "{{5000:bash ${./bluetooth.sh} button}}"
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
            class = "header"
            label = "<span weight='ultrabold'>Connected Devices: {{watch:while :; do echo $(bluetoothctl devices Connected | wc -l); sleep 5s; done}}</span>"
          }
          {
            type = "box"
            orientation = "horizontal"
            widgets = [
              {
                type = "script"
                name = "bluetooth-script"
                cmd = "bash ${./bluetooth.sh} popup"
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
''
