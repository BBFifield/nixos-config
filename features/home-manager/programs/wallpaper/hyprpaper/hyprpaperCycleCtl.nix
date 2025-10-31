{pkgs}:
pkgs.writeShellApplication {
  name = "hyprpaper-cyclectl";
  runtimeInputs = with pkgs; [socat];
  text = ''
    # hyprpaper-cyclectl status|stop
    set -euo pipefail

    RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    PIDFILE="$RUNTIME_DIR/hyprpaper-cycle.pid"

    status() {
      if [ -e "$PIDFILE" ]; then
        pid=$(cat "$PIDFILE" 2>/dev/null || true)
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
          printf 'running pid=%s\n' "$pid"
          exit 0
        else
          printf 'stale-pidfile\n'
          exit 1
        fi
      else
        printf 'not-running\n'
        exit 3
      fi
    }

    stopit() {
      if [ -e "$PIDFILE" ]; then
        pid=$(cat "$PIDFILE" 2>/dev/null || true)
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
          kill "$pid"
          printf 'sent SIGTERM to %s\n' "$pid"
          exit 0
        else
          printf 'no-process\n'
          rm -f "$PIDFILE"
          exit 1
        fi
      else
        printf 'not-running\n'
        exit 3
      fi
    }

    case "''${1:-status}" in
      status) status ;;
      stop) stopit ;;
      *) printf 'usage: %s [status|stop]\n' "$0"; exit 2 ;;
    esac
  '';
}
