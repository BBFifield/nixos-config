{
  config,
  pkgs,
}: {
  postStart = pkgs.writeShellApplication {
    name = "ironbar_post_start";
    runtimeInputs = with pkgs; [bash config.programs.ironbar.package coreutils socat];
    text = ''
      #!/usr/bin/env bash

      # Maximum number of retries
      MAX_RETRIES=20
      # Delay between retries in seconds
      DELAY=3
      # Counter for retries
      RETRIES=0

      tintednix=/etc/profiles/per-user/$(whoami)/bin/tintednix
      XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}

      until [ $RETRIES -ge $MAX_RETRIES ]
      do
        # Check if the Ironbar IPC socket is available and accepting connections
        if socat - UNIX-CONNECT:"$XDG_RUNTIME_DIR/ironbar-ipc.sock" 2>/dev/null; then
          echo "Connected to Ironbar IPC server"
          ironbar var set color_scheme "$($tintednix get color_scheme)"
          ironbar var set base00 "$($tintednix get base00)"
          ironbar var set base01 "$($tintednix get base01)"
          ironbar var set base02 "$($tintednix get base02)"
          ironbar var set base03 "$($tintednix get base03)"
          ironbar var set base04 "$($tintednix get base04)"
          ironbar var set base05 "$($tintednix get base05)"
          ironbar var set base06 "$($tintednix get base06)"
          ironbar var set base07 "$($tintednix get base07)"
          ironbar var set base08 "$($tintednix get base08)"
          ironbar var set base09 "$($tintednix get base09)"
          ironbar var set base0A "$($tintednix get base0A)"
          ironbar var set base0B "$($tintednix get base0B)"
          ironbar var set base0C "$($tintednix get base0C)"
          ironbar var set base0D "$($tintednix get base0D)"
          ironbar var set base0E "$($tintednix get base0E)"
          ironbar var set base0F "$($tintednix get base0F)"
          if [[ ! -f /home/brandon/ironbar_log.txt ]]; then
            touch /home/brandon/ironbar_log.txt
          fi
          exit 0
        else
          echo "Ironbar IPC server not available. Retrying in $DELAY seconds..."
        fi

        sleep $DELAY
        RETRIES=$((RETRIES+1))
      done
      if [[ ! -f /home/brandon/ironbar_log.txt ]]; then
        touch /home/brandon/ironbar_log.txt
      fi
      echo "Failed to connect to Ironbar IPC server after $MAX_RETRIES retries. Exiting."
      exit 1
    '';
  };
}
