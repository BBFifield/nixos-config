{pkgs}:
pkgs.writeShellScript "wallpaperonchange" ''
  set -euo pipefail

  DISPLAY="''${1:-}"
  WALLPAPER="''${2:-}"

  # returns filename without the final extension
  filename_no_ext() {
    local path="''${1:-}"
    local name
    name="$(basename -- "$path")"
    printf '%s\n' "''${name%.*}"
  }

  wallpaper_name=$(filename_no_ext $WALLPAPER)

  on_change() {
    ironbar var set wallpaper_name "$wallpaper_name"
  }

  on_change
''
