{
  config,
  pkgs,
}: let
  onWallpaperChange = import ../utilities/wallpaper/common/onChange.nix {inherit pkgs;};
in
  pkgs.writeShellApplication {
    name = "ironbar_post_start";
    runtimeInputs = with pkgs; [config.programs.ironbar.package coreutils socat libnotify];
    text = ''
      # Maximum number of retries
      MAX_RETRIES=20
      # Delay between retries in seconds
      DELAY=3
      # Counter for retries
      RETRIES=0

      tintednix="$(command -v tintednix || true)"
      XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
      # Hyprsunset state file
      HYPRSUNSET_STATEFILE="$XDG_RUNTIME_DIR/hyprsunset.state"

      WP_DAEMON="${config.hm.wallpaper.daemon}"

      read_statefile() {
        if [ -f "$1" ]; then
          cat "$1" 2>/dev/null || echo ""
        else
          echo ""
        fi
      }

      # Resolve ironbar binary once
      IRONBAR_BIN="$(command -v ironbar || true)"

      ironbar_set_var() {
        "$IRONBAR_BIN" var set "$1" "$2" >/dev/null 2>&1 || true
      }
      ironbar_add_class() {
        "$IRONBAR_BIN" style add-class tools nightLightOn >/dev/null 2>&1 || true
      }
      ironbar_remove_class() {
        "$IRONBAR_BIN" style remove-class tools nightLightOn >/dev/null 2>&1 || true
      }


      until [ $RETRIES -ge $MAX_RETRIES ]
      do
        # Check if the Ironbar IPC socket is available and accepting connections
        if socat - UNIX-CONNECT:"$XDG_RUNTIME_DIR/ironbar-ipc.sock" 2>/dev/null; then
          echo "Connected to Ironbar IPC server"

          # Set tintednix related ironvars
          ironbar_set_var color_scheme "$($tintednix --get color_scheme)"
          for i in $(seq 0 15); do
            base=$(printf "%02X" "$i")   # 00 .. 0F
            val="$($tintednix --get "base''${base}")"
            [ -n "$val" ] && ironbar_set_var "base''${base}" "$val"
          done

          # Wallpaper ironvars
          if [[ "''${WP_DAEMON:-}" == "wpaperd" ]]; then
            ${onWallpaperChange} "_" "$(readlink -f -- "${config.home.homeDirectory}/.local/state/wpaperd/wallpapers"/* | head -n1)"
          elif [[ "''${WP_DAEMON:-}" == "hyprpaper" ]]; then
            ${onWallpaperChange} "_" "$(hyprctl hyprpaper listactive | awk -F'=' '{gsub(/^ +| +$/,"",$2); print $2}')"
          fi

          # Determine states of hyprsunset ironvars by reading state file
          cur_hyprsunset_state="$(read_statefile "$HYPRSUNSET_STATEFILE")"
          if [ -n "$cur_hyprsunset_state" ]; then
            case "$cur_hyprsunset_state" in
              temp:*)
                state_type="temp"
                ;;
              identity)
                state_type="identity"
                ;;
              *)
                state_type="unknown"
                ;;
            esac
          else
            state_type="unknown"
          fi

          # Apply minimal, idempotent changes
          if [ "$state_type" = "temp" ]; then
            ironbar_set_var show_night_light_slider "true"
            ironbar_set_var night_light_status "ON"
            ironbar_add_class
          else
            ironbar_set_var show_night_light_slider "false"
            ironbar_set_var night_light_status "OFF"
            ironbar_remove_class
          fi

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
