{
  config,
  pkgs,
}: let
  cfg = config.hm.wallpaper;
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScript "wallpapersorttoggle" ''
    set -euo pipefail

    # Toggle wpaperd via wpaperctl (assumes wpaperctl is available)
    # Ironbar integration and notifications are conditional on config.hm.ironbar.enable

    ironbar_enabled=${
      if config.hm.ironbar.enable
      then "true"
      else "false"
    }

    notify_method() {
      ${notify-send} -a wpaperd -t 5000 -i preferences-desktop-wallpaper-symbolic 'Changed Wallpaper Sort Method' "Method is now $1"
    }

    ironbar_set_status() {
      [ "$ironbar_enabled" = "true" ] || return 0
      command -v ironbar >/dev/null 2>&1 || return 0
      ironbar var set wallpaper_sorting_method "$1"
    }

    WPAPERD_DIR="/home/$(whoami)/.config/wpaperd"
    STATEFILE="$WPAPERD_DIR/configs/wpaperd.state"

    write_state() {
      # printf '%s\n' "$1" > "$STATEFILE" 2>/dev/null || true
      gawk -i inplace -v src="$1" '
      { print src }
      ' "$STATEFILE" || true
    }

    read_state() {
      if [ -e "$STATEFILE" ]; then
        cat "$STATEFILE" 2>/dev/null || echo ${cfg.defaultSortMethod}
      else
        echo ${cfg.defaultSortMethod}
      fi
    }

    # Helper: return success if wpaperctl reports running
    service_running() {
      systemctl --user --quiet is-active wpaperd.service
    }

    # Read current observed state
    CUR_STATE="$(read_state)"

    ensure_service_started() {
      # start the service (no-op if already started)
      systemctl --user start wpaperd.service
    }

    switch_method() {
      # cp -P copies the symlink’s stored text exactly, preserving relative link text so the recreated symlink points the same way relative to the destination path.
      # This is okay for us as the link text in our symlinks are absolute, otherwise use ln -sfn "$(readlink "$1")" "$WPAPERD_DIR/wallpaper.toml".
      cp -Pf "$WPAPERD_DIR/configs/$1.toml" "$WPAPERD_DIR/wallpaper.toml"
    }

    # Determine whether wpaperd service is active; if not, start it but keep identity
    if ! service_running; then
      ensure_service_started
    fi

    if [ "${cfg.defaultSortMethod}" = "random" ]; then
      NON_DEFAULT="ordered"
      DEFAULT="random"
    else
      NON_DEFAULT="random"
      DEFAULT="ordered"
    fi

    case "$CUR_STATE" in
      $DEFAULT)
        if switch_method $NON_DEFAULT; then
          write_state $NON_DEFAULT
          ironbar_set_status ''${NON_DEFAULT^}
          notify_method ''${NON_DEFAULT^}
          exit 0
        else
          echo "Failed to apply $NON_DEFAULT sorting method" >&2
          exit 1
        fi
        ;;

      $NON_DEFAULT)
        if switch_method $DEFAULT; then
          write_state $DEFAULT
          ironbar_set_status ''${DEFAULT^}
          notify_method ''${DEFAULT^}
          exit 0
        else
          echo "Failed to apply $DEFAULT sorting method" >&2
          exit 1
        fi
        ;;
    esac
  ''
