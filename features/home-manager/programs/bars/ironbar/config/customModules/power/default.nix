{config, ...}: ''
  $profile_picture = "/var/lib/AccountsService/icons/{{echo $(whoami)}}"
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
    then "wleave -l /home/$(whoami)/.config/wleave/layoutLogout.json -C /home/$(whoami)/.config/wleave/style.css -T 430 -R 850 -B 430 -L 850"
    else "loginctl terminate-user $(whoami)"
  }"
              }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰌾</span>" on_click = "!${
    if config.hm.wleave.enable
    then "wleave -l /home/$(whoami)/.config/wleave/layoutLock.json -C /home/$(whoami)/.config/wleave/style.css -T 430 -R 850 -B 430 -L 850"
    else "loginctl lock-session"
  }"
              }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰐥</span>" on_click = "!${
    if config.hm.wleave.enable
    then "wleave -l /home/$(whoami)/.config/wleave/layoutShutdown.json -C /home/$(whoami)/.config/wleave/style.css -T 430 -R 850 -B 430 -L 850"
    else "poweroff"
  }"
              }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰜉</span>" on_click = "!${
    if config.hm.wleave.enable
    then "wleave -l /home/$(whoami)/.config/wleave/layoutReboot.json -C /home/$(whoami)/.config/wleave/style.css -T 430 -R 850 -B 430 -L 850"
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
