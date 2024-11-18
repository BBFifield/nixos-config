{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.snow-globe.targets.ironbar;
  snow-globe.lib = import ../../lib {inherit config pkgs lib;};
  sassColorsSet = config.snow-globe.sassColors;

  initialStyleFile = let
    defaultName = lib.getName config.snow-globe.defaultScheme;
  in
    snow-globe.lib.mkStyleFile defaultName (sassColorsSet.${defaultName}) "ironbar" ''
      sass "$out/style_ironbar.scss" "$out/.config/ironbar/style.css"
    ''
    cfg.styleFile;
in {
  options.snow-globe.targets.ironbar = {
    enable = lib.mkEnableOption "Enable ironbar statusbar.";
    styleFile = lib.mkOption {
      type = lib.types.path;
      default = ./config/style_ironbar.scss;
    };
    hot-reload = lib.mkOption {
      type = (import ../../../../submodules {inherit lib;}).hot-reload;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          playerctl
          swaynotificationcenter
        ];

        programs.ironbar = {
          enable = true;
          systemd = true;
          config = lib.mkForce "";
          style = lib.mkForce "";
        };
      }
      {
        home.packages = [initialStyleFile];
        xdg.configFile."ironbar/style.css" = {
          source = ''${initialStyleFile}/.config/ironbar/style.css'';
          onChange = ''
            (
              log_file="${config.home.homeDirectory}/ironbar-reload.log"
              echo "Checking for ironbar-ipc..." >> $log_file
              XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
              if [[ -S "$XDG_RUNTIME_DIR/ironbar-ipc.sock" ]]; then
                echo "ipc file exists" >> $log_file 2>&1
                ${pkgs.ironbar}/bin/ironbar load-css "${config.home.homeDirectory}/.config/ironbar/style.css"
              else
                echo "ipc file doesn't exist" >> $log_file
              fi
            )
          '';
        };
        xdg.configFile."ironbar/config.corn".source = ./config/config.corn;
        xdg.configFile."ironbar/sys_info.sh".source = ./config/sys_info.sh;
      }

      (
        lib.mkIf (!cfg.hot-reload.enable) {
          xdg.configFile."ironbar" = {
            source = ./config;
            recursive = true;
          };
        }
      )

      (
        lib.mkIf (cfg.hot-reload.enable) (let
          styleFiles = snow-globe.lib.mkStyleFiles "ironbar" sassColorsSet cfg.styleFile;

          linkedStyleFiles = snow-globe.lib.linkStyleFiles "ironbar" styleFiles;
        in
          lib.mkMerge [
            {
              hm.theme.hot-reload.scriptParts = lib.mkMerge [
                ''
                  cp -rf "$directory/ironbar/ironbar_colorschemes/$1.css" "$directory/ironbar/style.css"
                ''
                (lib.mkAfter ''
                  ironbar load-css "$directory/ironbar/style.css"
                '')
              ];

              home.packages = lib.attrValues styleFiles;
            }
            linkedStyleFiles
          ])
      )
    ]
  );
}
