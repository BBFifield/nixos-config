{config, ...}: ''
  $wleave_dir = "/home/$(whoami)/.config/wleave"

  $power_popup = {
    type = "custom"
    name = "power"
    bar = [ { type = "button" label = "" on_click = "popup:toggle" } ]
    popup = [
      {
        type = "box"
        orientation = "vertical"
        widgets = [
          { type = "label" class = "header" name = "profile-header" label = "{{echo $(whoami)}}" }
          {
            type = "box"
            orientation = "horizontal"
            halign = "center"
            widgets = [
              {
                type = "button" name = "profile-pic-button" orientation = "horizontal"
              }
            ]
          }
          {
            type = "box"
            name = "power-actions-box"
            widgets = [
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰗽</span>" on_click = "!${
    if config.hm.wleave.enable
    then "XDG_CONFIG_HOME=$wleave_dir wleave -x -l $wleave_dir/layoutLogout.json -T 430 -R 850 -B 430 -L 850"
    else "loginctl terminate-user $(whoami)"
  }"
              }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰌾</span>" on_click = "!${
    if config.hm.wleave.enable
    then "XDG_CONFIG_HOME=$wleave_dir wleave -x -l $wleave_dir/layoutLock.json -T 430 -R 850 -B 430 -L 850"
    else "loginctl lock-session"
  }"
              }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰐥</span>" on_click = "!${
    if config.hm.wleave.enable
    then "XDG_CONFIG_HOME=$wleave_dir wleave -x -l $wleave_dir/layoutShutdown.json -T 430 -R 850 -B 430 -L 850"
    else "poweroff"
  }"
              }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰜉</span>" on_click = "!${
    if config.hm.wleave.enable
    then "XDG_CONFIG_HOME=$wleave_dir wleave -x -l $wleave_dir/layoutReboot.json -T 430 -R 850 -B 430 -L 850"
    else "reboot"
  }"
              }
            ]
          }
        ]
      }
    ]
  }
''
