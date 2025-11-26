{pkgs}:
pkgs.writeShellScript "mk-writeable" ''
  set -euo pipefail

  src="$1"
  dst="$2"
  dir=$(dirname -- "$dst")
  base=$(basename -- "$dst")
  user=$(id -un)
  group=$(id -gn)

  # ensure parent exists
  mkdir -p -- "$dir"

  # resolve source (fail early if missing)
  if ! [ -e "$src" ]; then
    echo "error: source missing: $src" >&2
    exit 2
  fi

  # create a temp file in the destination directory (atomic mv later)
  tmp=$(mktemp -- "$dir/.''${base}.tmp.XXXXXX")
  trap 'rm -f -- "$tmp"' EXIT

  # copy dereferenced contents (if $src is symlink, cp --dereference follows it)
  if ! cp --dereference -- "$src" "$tmp"; then
    echo "error: copy failed from $src to $tmp" >&2
    exit 1
  fi

  # ensure owner and permissions suitable for the user
  chmod 0644 -- "$tmp"
  chown "$user":"$group" -- "$tmp" 2>/dev/null || true

  # atomic move over the destination (replaces file or symlink)
  mv -f -- "$tmp" "$dst"
  trap - EXIT

  echo "ok: wrote $dst"
''
