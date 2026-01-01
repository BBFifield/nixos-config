{pkgs}:
pkgs.writeShellScript "mk-writeable" ''
  set -euo pipefail

  src="$1"
  dst="$2"
  user=$(id -un)
  group=$(id -gn)

  # Normalize: if dst ends with slash or is an existing dir, treat as directory target
  case "$dst" in */) dst_is_dir=1 ;; *) dst_is_dir=0 ;; esac
  [ -d "$dst" ] && dst_is_dir=1

  if ! [ -e "$src" ]; then
    echo "error: source missing: $src" >&2
    exit 2
  fi

  # If src is a file and dst is a directory target, place inside that directory
  if [ -f "$src" ] && [ "$dst_is_dir" -eq 1 ]; then
    mkdir -p -- "$dst"
    dst="$dst/$(basename -- "$src")"
  fi

  dst_parent=$(dirname -- "$dst")
  mkdir -p -- "$dst_parent"

  # Create a temp workspace that always gets cleaned
  tmp=$(mktemp -d -- "$dst_parent/.mkwriteable.XXXXXX")
  cleanup() { rm -rf -- "$tmp"; }
  trap cleanup EXIT

  if [ -f "$src" ]; then
    # File case: copy into tmp, then atomic mv
    cp --dereference -- "$src" "$tmp/file"
    chmod 0644 "$tmp/file"
    chown "$user":"$group" "$tmp/file" 2>/dev/null || true
    mv -f -- "$tmp/file" "$dst"
    echo "ok: wrote file $dst"
    exit 0
  fi

  if [ -d "$src" ]; then
    # Directory case: copy contents into tmp
    cp -a --dereference -- "$src"/. "$tmp"/

    # Fix permissions
    find "$tmp" -type d -exec chmod 0755 {} +
    find "$tmp" -type f -exec chmod 0644 {} +
    chown -R "$user":"$group" "$tmp" 2>/dev/null || true

    # Merge: move each entry into dst, overwriting same-named entries
    mkdir -p -- "$dst"

    for entry in "$tmp"/* "$tmp"/.[!.]* "$tmp"/..?*; do
      [ -e "$entry" ] || continue
      name=$(basename -- "$entry")

      # If both sides are directories, replace destination directory wholesale
      if [ -d "$entry" ] && [ -d "$dst/$name" ]; then
        rm -rf -- "$dst/$name"
      fi

      mv -f -- "$entry" "$dst/"
    done

    echo "ok: merged directory $src -> $dst"
    exit 0
  fi

  echo "error: unsupported source type: $src" >&2
  exit 3
''
