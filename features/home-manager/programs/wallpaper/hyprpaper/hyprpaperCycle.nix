{pkgs}:
pkgs.writeShellApplication {
  name = "hyprpapercycle";
  runtimeInputs = with pkgs; [jq];
  text = ''
    # cycle DIRECTORY [INTERVAL]
    # Run inside Hyprland session (autostart). Writes a PID file for status queries.

    DIR="''${1:?Usage: $0 DIRECTORY [INTERVAL]}"
    INTERVAL="''${2:-300}"

    # Paths
    RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    PIDFILE="$RUNTIME_DIR/hyprpapercycle.pid"
    LOGFILE="$RUNTIME_DIR/hyprpapercycle.log"

    # state
    stop_requested=0

    # shellcheck disable=SC2329
    _on_stop() {
      stop_requested=1
    }
    trap _on_stop INT TERM

    # write pidfile
    printf '%s\n' "$$" > "$PIDFILE"

    # logging helper
    log() { printf '%s %s\n' "$(date --iso-8601=seconds)" "$*" >>"$LOGFILE"; }

    # random key generator (8 chars)
    randkey() {
      head -c 32 /dev/urandom 2>/dev/null | tr -dc 'A-Za-z0-9' | head -c 8
    }

    # shellcheck disable=SC2329
    cleanup() {
      rm -f "$PIDFILE"
    }
    trap cleanup EXIT

    log "starting hyprpapercycle for $DIR (interval=''${INTERVAL}s)"

    while [ $stop_requested -eq 0 ]; do
      # build shuffled list (NUL-safe)
      mapfile -d ''' -t images < <(
        while IFS= read -r -d $'\0' f; do
          printf '%s\t%s\0' "$(randkey)" "$f"
        done < <(find "$DIR" -type f -print0) \
        | sort -z -n \
        | cut -z -f2- 2>/dev/null || \
        { # fallback if cut -z not available
            while IFS= read -r -d $'\0' rec; do
              printf '%s\0' "''${rec#*$'\t'}"
            done < <(while IFS= read -r -d $'\0' f; do printf '%s\t%s\0' "$(randkey)" "$f"; done < <(find "$DIR" -type f -print0) | sort -z -n)
          }
      )

      total=''${#images[@]}
      idx=0

      while [ "$idx" -lt "$total" ] && [ "$stop_requested" -eq 0 ]; do
        img="''${images[$idx]}"
        # get monitors once per image
        mapfile -t monitors < <(hyprctl monitors -j 2>/dev/null | jq -r '.[]?.name' 2>/dev/null || printf 'default\n')

        for d in "''${monitors[@]}"; do
          [ -z "$img" ] && break 2
          log "reload monitor=$d img=$img"
          hyprctl hyprpaper reload "$d", "$img" 2>>"$LOGFILE" || log "hyprctl failed for $d"
          idx=$((idx + 1))
          img="''${images[$idx]:-}"
          [ $stop_requested -eq 1 ] && break 2
        done

        # responsive sleep
        slept=0
        while [ $slept -lt "$INTERVAL" ] && [ $stop_requested -eq 0 ]; do
          sleep 1
          slept=$((slept + 1))
        done
      done
    done

    log "stopping hyprpapercycle"
    exit 0
  '';
}
