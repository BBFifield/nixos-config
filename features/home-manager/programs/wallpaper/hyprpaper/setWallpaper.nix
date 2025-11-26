{pkgs}: let
  onChange = import ../common/onChange.nix {inherit pkgs;};
in
  pkgs.writeShellApplication {
    name = "set-wallpaper";
    runtimeInputs = with pkgs; [jq];
    text = ''
      USAGE="Usage: $0 <path-to-image>"

      img="''${1:-}"
      if [ -z "$img" ]; then
        printf '%s\n' "$USAGE" >&2
        exit 2
      fi

      if [ ! -f "$img" ]; then
        printf 'error: file not found: %s\n' "$img" >&2
        exit 3
      fi

      RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
      LOGFILE="$RUNTIME_DIR/hyprpaper-apply-primary.log"

      log() {
        printf '%s %s\n' "$(date --iso-8601=seconds)" "$*" >>"$LOGFILE" 2>/dev/null || true
      }

      # Get monitors JSON robustly; if hyprctl fails, primary becomes "default"
      monitors_json="$(hyprctl monitors -j 2>/dev/null || printf \'\')"

      # If jq present and monitors_json looks non-empty, try robust selection:
      if [ -n "$monitors_json" ] && command -v jq >/dev/null 2>&1; then
        # 1) prefer .focused == true
        primary="$(printf '%s' "$monitors_json" | jq -r '
          ( .[]? | select(.focused == true) | .name ) // empty
        ' 2>/dev/null || true)"

        # 2) if none focused, choose monitor with smallest x then smallest y (top-left)
        if [ -z "$primary" ]; then
          primary="$(printf '%s' "$monitors_json" | jq -r '
            ( .[]? | {name: .name, x: (.x // 0), y: (.y // 0)} )
            | sort_by(.x, .y) | .[0]?.name // empty
          ' 2>/dev/null || true)"
        fi

        # 3) fallback to first monitor name if still empty
        if [ -z "$primary" ]; then
          primary="$(printf '%s' "$monitors_json" | jq -r '.[0]?.name // empty' 2>/dev/null || true)"
        fi
      else
        primary=""
      fi

      if [ -z "$primary" ]; then
        log "could not determine primary monitor via hyprctl; using default"
        primary="default"
      fi

      # perform the reload and log hyprctl output
      if hyprctl hyprpaper reload "$primary", "$img" >>"$LOGFILE" 2>&1; then
        ${onChange} "$primary" "$img"
        log "applied $img to primary=$primary"
        printf 'OK primary=%s\n' "$primary"
        exit 0
      else
        log "failed to apply $img to primary=$primary (hyprctl exit)"
        printf 'ERR failed to apply %s to %s\n' "$img" "$primary" >&2
        exit 4
      fi
    '';
  }
