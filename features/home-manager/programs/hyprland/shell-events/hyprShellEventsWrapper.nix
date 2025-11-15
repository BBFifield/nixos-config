{
  config,
  pkgs,
}: let
  hyprShellEvents = import ./hyprShellEvents.nix {inherit config pkgs;};
in
  pkgs.writeShellApplication {
    name = "hyprshelleventswrapper";
    runtimeInputs = with pkgs; [hyprland jq socat shellevents];
    text = ''
      XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

      HYPRLAND_INSTANCE_SIGNATURE=""
      if [ -d "/tmp/hypr" ] || [ -d "$XDG_RUNTIME_DIR/hypr" ]; then
        for inst in $(hyprctl instances -j | jq -r ".[].instance"); do
          HYPRLAND_INSTANCE_SIGNATURE="$inst"
          break
        done
      fi

      sock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
      if [ ! -e "$sock" ]; then
        echo "hypr socket not found: $sock" >&2
        exit 1
      fi

      exec socat -u \
        "UNIX-CONNECT:$sock" \
        "EXEC:shellevents ${hyprShellEvents}/bin/hyprshellevents",nofork
    '';
  }
