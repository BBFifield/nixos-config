{
  config,
  pkgs,
}:
pkgs.writeShellApplication {
  name = "ironbar_post_start";
  runtimeInputs = with pkgs; [config.programs.ironbar.package coreutils socat];
  text = ''
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
        ironbar var set color_scheme "$($tintednix --get color_scheme)"
        for base in {00..0F}; do
          val="$($tintednix --get "base0''${base}")"
          ironbar var set "base0''${base}" "$val"
        done
        exit 0
      else
        echo "Ironbar IPC server not available. Retrying in $DELAY seconds..."
      fi

      sleep $DELAY
      RETRIES=$((RETRIES+1))
    done
    echo "Failed to connect to Ironbar IPC server after $MAX_RETRIES retries. Exiting."
    exit 1
  '';
}
