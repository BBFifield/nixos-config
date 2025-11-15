{pkgs, ...}:
pkgs.writeShellScript "ensurewriteable" ''
  set -euo pipefail

  prog=''${0##*/}
  file=''${1:-}

  usage() {
    cat <<EOF
  Usage: $prog /path/to/config.conf

  If /path/to/config.conf is a symlink, replace that symlink with a regular
  file containing the dereferenced target's contents. The new file will be
  created in the same directory and will be writable by the invoking user.

  If the directory is not writable, the script will request sudo to create
  the temp file and perform the atomic replace (it does not modify the
  symlink target in the Nix store).
  EOF
    exit 2
  }

  [[ -n "$file" ]] || usage

  if [[ ! -e "$file" && ! -L "$file" ]]; then
    echo "error: path does not exist: $file" >&2
    exit 2
  fi

  dir=$(dirname -- "$file")
  base=$(basename -- "$file")
  user=$(id -un)

  # find dereferenced target path (if symlink); if it's a regular file use it
  if [[ -L "$file" ]]; then
    target=$(readlink -f -- "$file")
  else
    target="$file"
  fi

  if [[ ! -e "$target" ]]; then
    echo "error: target does not exist: $target" >&2
    exit 2
  fi

  # If the file already exists and is writable by user, nothing to do
  if [[ -w "$file" && ! -L "$file" ]]; then
    echo "ok: file is already writable: $file"
    exit 0
  fi

  # Helper: perform atomic replace assuming we can create tmp in $dir as current user
  do_local_replace() {
    local tmp
    tmp=$(mktemp "''${dir}/.''${base}.tmp.XXXXXX")
    trap 'rm -f -- "$tmp"' EXIT

    # copy dereferenced contents
    if ! cp --dereference -- "$target" "$tmp"; then
      echo "error: failed to copy from $target to $tmp" >&2
      return 1
    fi

    # ensure owned by invoking user and writable
    chmod u+rw -- "$tmp"
    chown "$user" -- "$tmp" 2>/dev/null || true

    # atomic move over the original path (replaces symlink or file)
    mv -- "$tmp" "$file"
    trap - EXIT
    echo "replaced: $file (now a regular writable file)"
    return 0
  }

  # If directory writable by current user, do it directly
  if [[ -w "$dir" ]]; then
    do_local_replace || exit 1
    exit 0
  fi

  exit 0
''
