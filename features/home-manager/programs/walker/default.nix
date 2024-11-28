{
  config,
  pkgs,
  lib,
  ...
}: let
  # tintednix.lib = import ../../../lookAndFeel/tintednix/lib {inherit config pkgs lib;};
  compiledSassFile = pkgs.runCommand "style_walker" {nativeBuildInputs = with pkgs; [dart-sass];} ''
    #!/usr/bin/env bash
    mkdir -p $out
    cp -rf "${./config/style_walker.scss}" "$out/style_walker.scss"
    sass "$out/style_walker.scss" "$out/.config/walker/themes/style.css"
    CSS_FILE="$out/.config/walker/themes/style.css"

    { echo "@import url('file://${config.home.homeDirectory}/.config/walker/themes/colors.css');"; cat "$CSS_FILE"; } > temp_file && mv temp_file "$CSS_FILE"
  '';
in {
  options.hm.walker = {
    enable = lib.mkEnableOption "Enable Walker launcher.";
    width = lib.mkOption {
      type = lib.types.int;
      default = 600;
    };
    height = lib.mkOption {
      type = lib.types.int;
      default = 400;
    };
  };

  config = lib.mkIf config.hm.walker.enable (
    lib.mkMerge [
      {
        home.packages = [compiledSassFile];
        xdg.configFile."walker/themes/style.css" = {
          source = "${compiledSassFile}/.config/walker/themes/style.css"; #./config/style_walker.css;
          onChange = ''
            (
              log_file="${config.home.homeDirectory}/walker-reload.log"
              echo "Checking for walker..." >> $log_file
              XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
              if [[ -S "$XDG_RUNTIME_DIR/walker-dmenu.sock" ]]; then
                echo "ipc file exists" >> $log_file 2>&1
                ${pkgs.walker}/bin/walker --theme style
              else
                echo "ipc file doesn't exist" >> $log_file
              fi
            )
          '';
        };
        xdg.configFile."walker/themes/style.json".text = (import ./config/layout.nix {inherit config lib;}).layout;
      }
      {
        programs.walker = {
          enable = true;
          runAsService = false;
          config = {
            theme = "style";
            as_window = true;
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
              {
                "name" = "color scheme";
                "placeholder" = "Color Scheme";
                "prefix" = ",";
                "switcher_only" = false;
                "eager_loading" = true;
                "refresh" = true;
                "recalculate_score" = false;
                "show_icon_when_single" = true;
                "entries" = let
                  entries =
                    lib.mapAttrsToList (schemeName: schemeValue: {
                      "label" = "${schemeName}";
                      "exec" = "tintednix ${schemeName} ${schemeValue.variant}";
                    })
                    config.tintednix.commonColors;
                  /*
                    lib.map (scheme: let
                    schemeName =
                      if lib.isDerivation scheme
                      then lib.getName scheme
                      else builtins.trace scheme.name scheme.name;
                  in {
                    "label" = "${schemeName}";
                    "exec" = "tintednix ${schemeName} ${(config.tintednix.commonColors).${schemeName}.variant}";
                  })
                  (
                    if config.tintednix.enabledSchemes == "all"
                    then lib.filter (packageAttr: packageAttr.name != "rose-pine-moon" && packageAttr.name != "rose-pine-dawn" && packageAttr.name != "rose-pine" && packageAttr.name != "override" && packageAttr.name != "overrideDerivation") (lib.attrsToList pkgs.base16)
                    else config.tintednix.enabledSchemes
                  );
                  */
                in
                  entries;
              }
            ];
          };
        };
      }
    ]
  );
}
