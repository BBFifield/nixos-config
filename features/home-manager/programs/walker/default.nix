{
  config,
  pkgs,
  lib,
  ...
}: {
  options.hm.walker = {
    enable = lib.mkEnableOption "Enable Walker launcher.";
  };

  config = lib.mkIf config.hm.walker.enable (
    lib.mkMerge [
      {
        programs.walker = {
          enable = true;
          runAsService = true;
          config = {
            #theme = "style";
            #as_window = true;
            disable_click_to_close = false;
            ui.fullscreen = true;
            websearch.prefix = "?";
            switcher.prefix = "/";
            plugins = [
              {
                "name" = "power";
                "placeholder" = "Power";
                "switcher_only" = true;
                "recalculate_score" = true;
                "show_icon_when_single" = true;
                "entries" = [
                  {
                    "label" = "Shutdown";
                    "icon" = "system-shutdown";
                    "exec" = "shutdown now";
                  }
                  {
                    "label" = "Reboot";
                    "icon" = "system-reboot";
                    "exec" = "reboot";
                  }
                  {
                    "label" = "Lock Screen";
                    "icon" = "system-lock-screen";
                    "exec" = "playerctl --all-players pause & hyprlock";
                  }
                ];
              }
            ];
          };
        };
      }

      (
        lib.mkIf (!config.hm.hot-reload.enable) {
          programs.walker.runAsService = true;
          xdg.configFile."walker" = {
            source = ./config;
            recursive = true;
          };
        }
      )
    ]
  );
}
