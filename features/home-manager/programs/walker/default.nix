{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.hm.walker = {
    enable = mkEnableOption "Enable Walker launcher.";
  };

  config = mkIf config.hm.walker.enable {
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        search.placeholder = "Example";
        ui.fullscreen = true;
        list = {
          height = 200;
        };
        websearch.prefix = "?";
        switcher.prefix = "/";
      };
    };
  };
}
