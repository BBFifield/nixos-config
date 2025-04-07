{
  config,
  lib,
  ...
}:
with lib; {
  options.hm.wpaperd = {
    enable = mkEnableOption "Enable wpaperd.";
  };

  config = mkIf config.hm.wpaperd.enable {
    services.wpaperd = {
      enable = true;
      settings = {
        default = {
          duration = "30m";
          mode = "center";
          sorting = "random";
          transition = {
            hexagonalize = {};
          };
        };
        any = {
          path = "${config.home.homeDirectory}/Pictures/wallpapers";
        };
      };
    };
  };
}
