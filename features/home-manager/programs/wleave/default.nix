{
  config,
  pkgs,
  lib,
  ...
}: {
  options.hm.wleave = {
    enable = lib.mkEnableOption "Enable wleave. A wlogout fork re-written in rust with more polish.";
  };

  config = lib.mkIf config.hm.wleave.enable {
    xdg.configFile = {
      "wleave/style.css" = {
        text = import ./config/style.nix {inherit config pkgs;};
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

    home.packages = with pkgs; [
      wleave
    ];
  };
}
