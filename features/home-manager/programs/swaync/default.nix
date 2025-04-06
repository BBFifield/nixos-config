{
  config,
  lib,
  ...
}: {
  options.hm.swaync = {
    enable = lib.mkEnableOption "Enable swaync support";
  };

  config = lib.mkIf config.hm.swaync.enable {
    services.swaync = {
      enable = true;
      style = import ./config/style.nix config;
    };
  };
}
