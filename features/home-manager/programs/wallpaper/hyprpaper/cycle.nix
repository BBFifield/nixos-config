{
  config,
  pkgs,
}: let
  onChange = import ../common/onChange.nix {inherit pkgs;};
  interval = builtins.toString config.hm.wallpaper.interval;
in
  pkgs.writeShellApplication {
    name = "hyprpapercycle";
    runtimeInputs = with pkgs; [jq];
    text = ''
      # cycle [INTERVAL] [MODE]
      # Run inside Hyprland session (autostart). Writes a PID file for status queries.

      DIR="${config.home.homeDirectory}/Pictures/wallpapers"
      INTERVAL="''${1:-${interval}}"

      if [ -z "$INTERVAL" ]; then
        printf 'Usage: %s [INTERVAL] [MODE]\n' "$0" >&2
        exit 2
      fi

      # Paths
      RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
      PIDFILE="$RUNTIME_DIR/hyprpapercycle.pid"
      LOGFILE="$RUNTIME_DIR/hyprpapercycle.log"
      MODEFILE="$RUNTIME_DIR/hyprpapercycle.mode"

      # state
      stop_requested=0

      # shellcheck disable=SC2329
      _on_stop() {
        stop_requested=1
      }
      trap _on_stop INT TERM

      # logging helper
      log() { printf '%s %s\n' "$(date --iso-8601=seconds)" "$*" >>"$LOGFILE"; }

      # random key generator (8 chars)
      randkey() {
        head -c 32 /dev/urandom 2>/dev/null | tr -dc 'A-Za-z0-9' | head -c 8
      }

      # cleanup
      # shellcheck disable=SC2329
      cleanup() {
        rm -f "$PIDFILE"
      }
      trap cleanup EXIT

      # write pidfile
      printf '%s\n' "$$" > "$PIDFILE"

      # read persisted mode or accept 3rd arg; default random
      if [ -f "$MODEFILE" ]; then
        mode="$(cat "$MODEFILE" 2>/dev/null || echo "random")"
      else
        mode="''${2:-random}"
        printf '%s\n' "$mode" > "$MODEFILE"
      fi

      # allow runtime reload of mode via USR1
      # shellcheck disable=SC2329
      _reload_mode() {
        if [ -f "$MODEFILE" ]; then
          mode="$(cat "$MODEFILE" 2>/dev/null || echo "$mode")"
          log "mode reloaded -> $mode (USR1)"
        fi
      }
      trap _reload_mode USR1

      log "starting hyprpapercycle for $DIR (interval=''${INTERVAL}s mode=$mode)"

      build_images() {
        images=()
        if [ "''${mode:-random}" = "ordered" ]; then
          # ordered: lexicographic, NUL-safe
          if mapfile -d $'\0' -t images < <(find "$DIR" -type f -print0 | sort -z); then
            :
          else
            images=()
          fi
        else
          # random: original behavior (randkey shuffle)
          SHUFFILE="$RUNTIME_DIR/hyprpapercycle.shuffle.$$"
          rm -f "$SHUFFILE"
          while IFS= read -r -d $'\0' f; do printf '%s\t%s\0' "$(randkey)" "$f"; done < <(find "$DIR" -type f -print0) > "$SHUFFILE" || true
          if [ -s "$SHUFFILE" ]; then
            # preferred fast path: cut -z available
            if command -v cut >/dev/null 2>&1 && printf \'\' | cut -z >/dev/null 2>&1; then
              mapfile -d $'\0' -t images < <(sort -z -n "$SHUFFILE" | cut -z -f2- 2>/dev/null)
            else
              # fallback: safe extraction
              while IFS= read -r -d $'\0' rec; do images+=( "''${rec#*$'\t'}" ); done < <(sort -z -n "$SHUFFILE")
            fi
          fi
          rm -f "$SHUFFILE"
        fi
      }

      # main loop
      while [ $stop_requested -eq 0 ]; do
        build_images
        total=''${#images[@]}
        idx=0

        if [ "$total" -le 0 ]; then
          log "no images found in $DIR; sleeping ''${INTERVAL}s"
          sleep "$INTERVAL"
          continue
        fi

        while [ "$idx" -lt "$total" ] && [ "$stop_requested" -eq 0 ]; do
          img="''${images[$idx]}"
          # get monitors once per image
          mapfile -t monitors < <(hyprctl monitors -j 2>/dev/null | jq -r '.[]?.name' 2>/dev/null || printf 'default\n')

          applied_any=0
          for mon in "''${monitors[@]}"; do
            [ -z "$img" ] && break 2
            log "reload monitor=$mon img=$img"
            if hyprctl hyprpaper reload "$mon", "$img" >>"$LOGFILE" 2>&1; then
              if [ "$applied_any" -eq 0 ]; then
                ${onChange} "$mon" "$img"
              fi
              log "applied img=$img to monitor=$mon"
              applied_any=1
            else
              log "hyprctl failed applying img=$img to monitor=$mon"
            fi
            idx=$((idx + 1))
            img="''${images[$idx]:-}"
            [ "$stop_requested" -eq 1 ] && break 2
          done
          applied_any=0

          # responsive sleep
          slept=0
          while [ "$slept" -lt "$INTERVAL" ] && [ "$stop_requested" -eq 0 ]; do
            sleep 1
            slept=$((slept + 1))
          done
        done
      done

      log "stopping hyprpapercycle"
      exit 0
    '';
  }
