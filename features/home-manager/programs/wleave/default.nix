{
  config,
  pkgs,
  lib,
  ...
}: let
  sassFile = import ./config/style.nix config pkgs;
  compiledSassFile =
    pkgs.runCommand "style_wleave" {nativeBuildInputs = with pkgs; [dart-sass jq];}
    ''
      #!/usr/bin/env bash
      mkdir -p $out
      cat > "$out/styleWleave.scss" <<'EOF'
      ${sassFile}
      EOF
      sass "$out/styleWleave.scss" "$out/.config/wleave/gtk-4.0/gtk.css"
    '';
in {
  options.hm.wleave = {
    enable = lib.mkEnableOption "Enable wleave. A wlogout fork re-written in rust with more polish.";
  };

  config = lib.mkIf config.hm.wleave.enable {
    home.packages = [compiledSassFile pkgs.wleave];

    xdg.configFile = {
      # XDG_CONFIG_HOME points to wleave directory to stop /.config/gtk-4.0/gtk.css from overriding the css
      # "wleave/gtk-4.0/gtk.css" = {
      #   text = import ./config/style.nix {inherit config pkgs;};
      # };
      "wleave/gtk-4.0/gtk.css" = {
        source = "${compiledSassFile}/.config/wleave/gtk-4.0/gtk.css";
        onChange = '''';
      };
      "wleave/layoutLock.json" = {
        text = ''
          {
            "buttons": [
              {
                "label": "lock",
                "action": "loginctl lock-session",
                "text": "󰌾",
                "height": 0.5,
                "width": 0.5,
                "keybind": "l",
                "circular": true
              }
            ]
          }
        '';
      };
      "wleave/layoutLogout.json" = {
        text = ''
          {
            "buttons": [
              {
                "label": "logout",
                "action": "loginctl terminate-user $USER",
                "text": "󰗽",
                "height": 0.5,
                "width": 0.5,
                "keybind": "e",
                "circular": true
              }
            ]
          }
        '';
      };
      "wleave/layoutShutdown.json" = {
        text = ''
          {
            "buttons": [
              {
                "label": "shutdown",
                "action": "poweroff",
                "text": "󰐥",
                "height": 0.5,
                "width": 0.5,
                "keybind": "s",
                "circular": true
              }
            ]
          }
        '';
      };
      "wleave/layoutReboot.json" = {
        text = ''
          {
            "buttons": [
              {
                "label": "reboot",
                "action": "reboot",
                "text": "󰜉",
                "height": 0.5,
                "width": 0.5,
                "keybind": "r",
                "circular": true
              }
            ]
          }
        '';
      };
    };
  };
}
