{
  config,
  pkgs,
}: {
  hyprDisplays = pkgs.writeShellApplication {
    name = "hypr_displays";
    runtimeInputs = with pkgs; [bash socat];
    text = ''
      #!/usr/bin/env bash

      handle() {
        case $1 in
          monitoradded*) systemctl --user restart wpaperd.service ironbar.service ;;
        esac
      }

      socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done
    '';
  };
}
