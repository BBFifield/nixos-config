{pkgs}: let
  onChange = import ../common/onChange.nix {inherit pkgs;};
in
  pkgs.writeShellApplication {
    name = "hyprpapercyclestep";
    runtimeInputs = with pkgs; [jq];
    text = ''
      # Usage: hyprpapercyclestep DIRECTORY next|previous
      #
      # Applies the next (or previous) X images from DIRECTORY where X is the
      # number of monitors reported by hyprctl. Images are taken from a stable,
      # sorted list. The script keeps a small pointer file in XDG_RUNTIME_DIR to
      # remember the current position between invocations.
      #
      # Behavior:
      #  - Determine monitors (ordered list) via hyprctl monitors -j
      #  - Read/construct image list (regular files only) sorted lexicographically
      #  - Read pointer file (defaults to 0). For "next" advance by X then apply;
      #    for "prev" move back by X then apply.
      #  - Apply images[i + j] to monitor j (wraps around the list).
      #  - Update pointer to the first applied image index (committed on success).
      #
      # This is intentionally simple and deterministic so it composes with your
      # existing hyprpapercycle behavior.

      DIR="$HOME/Pictures/wallpapers"

      CMD="''${1:-}"

      if [ ! -d "$DIR" ]; then
        printf 'error: DIRECTORY not found: %s\n' "$DIR" >&2
        exit 3
      fi

      if [ -z "$CMD" ]; then
        printf 'Usage: %s next|previous\n' "$0" >&2
        exit 2
      fi
      case "$CMD" in
        next|previous) : ;;
        *) printf 'Usage: %s next|previous\n' "$0" >&2; exit 2 ;;
      esac


      RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
      PTRFILE="$RUNTIME_DIR/hyprpaper-cycle-step.ptr"
      LOGFILE="$RUNTIME_DIR/hyprpaper-cycle-step.log"

      log() {
        printf '%s %s\n' "$(date --iso-8601=seconds)" "$*" >>"$LOGFILE" 2>/dev/null || true
      }

      # discover monitors (ordered). Fallback to single "default"
      monitors_json="$(hyprctl monitors -j 2>/dev/null || printf \'\')"
      if [ -n "$monitors_json" ] && command -v jq >/dev/null 2>&1; then
        mapfile -t monitors < <(printf '%s' "$monitors_json" | jq -r '.[]?.name' 2>/dev/null || printf \'\')
      fi
      if [ "''${#monitors[@]}" -eq 0 ]; then
        monitors=(default)
      fi
      NMON=''${#monitors[@]}

      # build a sorted list of regular files (NUL-safe)
      images=()
      while IFS= read -r -d $'\0' f; do images+=("$f"); done < <(find "$DIR" -type f -print0 | sort -z)

      total=''${#images[@]}
      if [ "$total" -eq 0 ]; then
        printf 'error: no image files found in %s\n' "$DIR" >&2
        exit 4
      fi

      # read pointer (index of the first image applied in the last run)
      if [ -f "$PTRFILE" ]; then
        ptr=$(cat "$PTRFILE" 2>/dev/null || echo "0")
        # sanitize numeric
        case "$ptr" in \'\'|*[!0-9]*)
          ptr=0
          ;;
        esac
      else
        ptr=0
      fi

      # compute candidate start index
      if [ "$CMD" = "next" ]; then
        start=$(( (ptr + NMON) % total ))
      else
        # previous: move backwards by NMON
        start=$(( (ptr - NMON) % total ))
        # POSIX sh modulo may be negative; fix
        if [ "$start" -lt 0 ]; then start=$((start + total)); fi
      fi

      # For each monitor j apply images[(start + j) % total]
      applied_any=0
      for idx in $(seq 0 $((NMON - 1))); do
        sel=$(( (start + idx) % total ))
        img="''${images[$sel]}"
        mon="''${monitors[$idx]}"
        if hyprctl hyprpaper reload "$mon", "$img" >>"$LOGFILE" 2>&1; then
          if [ "$applied_any" -eq 0 ]; then
            ${onChange} "$mon" "$img"
          fi
          log "applied img=$img to monitor=$mon sel_idx=$sel"
          applied_any=1
        else
          log "hyprctl failed applying img=$img to monitor=$mon sel_idx=$sel"
          # continue trying other monitors; do not update pointer unless at least one success
        fi
      done



      if [ "$applied_any" -eq 1 ]; then
        # commit pointer: new pointer is start (first applied image)
        printf '%s\n' "$start" > "$PTRFILE"
        log "committed pointer start=$start (NMON=$NMON total=$total)"
        printf 'OK start=%s applied=%s monitors=%s\n' "$start" "$NMON" "''${#monitors[@]}"
        exit 0
      else
        log "no hyprctl apply succeeded; pointer unchanged ptr=$ptr start=$start"
        printf 'ERR no monitor accepted reload\n' >&2
        exit 5
      fi
    '';
  }
