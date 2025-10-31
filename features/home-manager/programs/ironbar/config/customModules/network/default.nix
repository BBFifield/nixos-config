{
  config,
  pkgs,
  ...
}: ''
  $network_popup = {
    type = "custom"
    name = "network"
    bar = [
      {
        type = "button"
        label = "{{watch:${import ./network.nix pkgs}}}"
        on_click = "!bash ${./toggle-nmgui.sh}"
        tooltip = "#network_status"
      }
    ]
  }
''
