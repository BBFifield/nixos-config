{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.hyprland.hyprsunset;
in {
  options.hm.hyprland.hyprsunset = {
    enable = lib.mkEnableOption "Enable ironbar statusbar.";
    initTemp = lib.mkOption {
      type = lib.types.str;
      default = "4000";
      description = ''Initial temperature set by hyprsunset'';
    };
    range = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["2000" "8000"];
      description = ''Range of possible temperature values'';
    };
  };

  config = lib.mkIf cfg.enable {
    services.hyprsunset = {
      enable = true;
    };
  };
}
