{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.snow-globe.targets.walker;
  snow-globe.lib = import ../../lib {inherit config pkgs lib;};
  sassColorsSet = config.snow-globe.sassColors;

  initialStyleFile = let
    defaultName = lib.getName config.snow-globe.defaultScheme;
  in
    snow-globe.lib.mkStyleFile defaultName (sassColorsSet.${defaultName}) "walker" ''
      sass "$out/style_walker.scss" "$out/.config/walker/themes/style.css"
    ''
    cfg.styleFile;
in {
  options.snow-globe.targets.walker = {
    enable = lib.mkEnableOption "Enable target, Walker launcher.";
    styleFile = lib.mkOption {
      type = lib.types.path;
      default = ./config/style_walker.scss;
    };
    layout = lib.mkOption {
      type = lib.types.lines;
      default = (import ./config/layout.nix {inherit config lib;}).layout;
    };
    width = lib.mkOption {
      type = lib.types.int;
      default = 600;
    };
    height = lib.mkOption {
      type = lib.types.int;
      default = 400;
    };
    hot-reload = lib.mkOption {
      type = (import ../../../../submodules {inherit lib;}).hot-reload;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [initialStyleFile];
        xdg.configFile."walker/themes/style.css" = {
          source = "${initialStyleFile}/.config/walker/themes/style.css";
          onChange = ''
            (
              log_file="${config.home.homeDirectory}/walker-reload.log"
              echo "Checking for walker..." >> $log_file
              XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
              if [[ -S "$XDG_RUNTIME_DIR/walker-dmenu.sock" ]]; then
                echo "ipc file exists" >> $log_file 2>&1
                ${pkgs.walker}/bin/walker --theme "${config.home.homeDirectory}/.config/walker/themes/style.css"
              else
                echo "ipc file doesn't exist" >> $log_file
              fi
            )
          '';
        };
        xdg.configFile."walker/themes/style.json".text = cfg.layout;
      }

      (
        lib.mkIf (!cfg.hot-reload.enable) {
          programs.walker.runAsService = true;
          xdg.configFile."walker" = {
            source = ./config;
            recursive = true;
          };
        }
      )

      (
        lib.mkIf (cfg.hot-reload.enable) (let
          styleFiles = snow-globe.lib.mkStyleFiles "walker" sassColorsSet cfg.styleFile;

          linkedStyleFiles = snow-globe.lib.linkStyleFiles "walker" styleFiles;
        in
          lib.mkMerge [
            {
              hm.theme.hot-reload.scriptParts = lib.mkMerge [
                ''
                  cp -rf "$directory/walker/walker_colorschemes/$1.css" "$directory/walker/themes/style.css"
                ''
                (lib.mkAfter ''
                  walker --theme "$directory/walker/themes/style.css"
                '')
              ];

              home.packages = lib.attrValues styleFiles;
            }
            linkedStyleFiles
            {
              programs.walker = {
                runAsService = lib.mkForce false;
                config = {
                  theme = "style";
                  as_window = true;
                  disable_click_to_close = false;
                  plugins = [
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
                          lib.map (schemeName: {
                            "label" = "${schemeName}";
                            "exec" = "switch-colorscheme ${schemeName} ${(config.snow-globe.commonColors).${schemeName}.variant}";
                          })
                          (lib.attrNames sassColorsSet);
                      in
                        entries;
                    }
                  ];
                };
              };
            }
          ])
      )
    ]
  );
}
