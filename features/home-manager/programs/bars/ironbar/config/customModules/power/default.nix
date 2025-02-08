config: ''
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
          {type = "image" name = "profile-pic" src = $profile_picture  size = 80 }
          {
            type = "box"
            name = "power-actions-box"
            widgets = [
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰗽</span>" on_click = "!loginctl terminate-user $(whoami)" }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰌾</span>" on_click = "!~/.config/hypr/start_hyprlock.sh" }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰐥</span>" on_click = "!poweroff" }
              { type = "button" class="power-btn" label = "<span font-size='25pt'>󰜉</span>" on_click = "!reboot" }
            ]
          }
        ]
      }
    ]
  }
''
