{
  config,
  lib,
  ...
}: let
  cfg = config.hm.hyprland;
in {
  options.hm.hyprland = {
    displayOutputs = lib.mkOption {
      description = "Monitor options";
      type = with lib.types;
        attrsOf (submodule {
          options = {
            displayProps = lib.mkOption {
              type = with types; nullOr (listOf str);
              default = null;
              example = ["highres@highrr" "0x0" "2"];
            };
            isHDRcapable = lib.mkOption {
              type = bool;
              default = false;
              description = ''Whether the monitor is capable of displaying HDR content.'';
            };
          };
        });
      example = {
        "HDMI-A-1" = {
          displayProps = ["highres@highrr" "0x0" "2"];
          isHDRcapable = true;
        };
      };
    };
  };
  config = lib.mkIf config.hm.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      experimental = let
        displays = config.hm.hyprland.displayOutputs;
        hasHDR = lib.any (display: display.isHDRcapable or false) (lib.attrValues displays);
      in {
        xx_color_management_v4 = hasHDR;
      };

      monitor = lib.mapAttrsToList (name: value: "${name}, ${lib.concatStringsSep "," value.displayProps}") cfg.displayOutputs;
    };
  };
}
