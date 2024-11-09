{
  config,
  pkgs,
  lib,
  ...
}: let
  jsonFormat = pkgs.formats.json {};

  attrset = import ../../lookAndFeel/colorschemeInfo.nix;

  mkColorPrefix = name: value: {
    name = "\$${name}";
    value = "#${value}";
  };

  mkColorsFile = value:
    pkgs.writeTextFile {
      name = "_walker_colors.scss";
      text = lib.concatStringsSep "\n" (lib.map (cognate: "${cognate.name}: ${cognate.value};") value);
    };

  mkCognateList = name: variant: let
    cognates = attrset.${name}.cognates variant;
  in
    lib.map (cognateName: mkColorPrefix cognateName cognates.${cognateName}) (lib.attrNames cognates);

  mkStyleFile = name: value: installPhase:
    pkgs.runCommand name {nativeBuildInputs = with pkgs; [dart-sass];} ''
      #!/usr/bin/env bash
      mkdir -p $out
      cp -rf "${mkColorsFile value}" "$out/_walker_colors.scss"
      cp -rf "${./config/style_walker.scss}" "$out/style_walker.scss"
      ${installPhase}
    '';

  initialStyleFile = let
    name = config.hm.theme.colorscheme.name;
    variant = config.hm.theme.colorscheme.variant;
  in
    mkStyleFile "${name}_${variant}" (mkCognateList name variant) ''
      sass "$out/style_walker.scss" "$out/.config/walker/themes/style.css"
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
    hot-reload = lib.mkOption {
      type = (import ../../submodules {inherit lib;}).hot-reload;
    };
  };

  config = lib.mkIf config.hm.walker.enable (
    lib.mkMerge [
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
          };
        };
      }
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
        xdg.configFile."walker/themes/style.json".text = let themeLayout = (import ./config/layout.nix {inherit config lib;}).layout; in themeLayout;
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

      (
        lib.mkIf (config.hm.walker.hot-reload.enable) (let
          themeNames = lib.attrNames attrset;
          getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

          unpacked = lib.concatMap (theme:
            lib.map (variant: {
              name = "${theme}_${variant}";
              value = mkCognateList theme variant;
            }) (getVariantNames theme))
          themeNames;

          styleFiles = lib.mapAttrs (name: value:
            mkStyleFile name value ''
              sass "$out/style_walker.scss" "$out/.config/walker/walker_colorschemes/${name}.css"
              rm "$out/_walker_colors.scss"
            '')
          (lib.listToAttrs unpacked);

          linkStyleFile = name: value: {
            xdg.configFile."walker/walker_colorschemes/${name}.css".source = "${value}/.config/walker/walker_colorschemes/${name}.css";
          };

          linkedStyleFiles = let
            names = lib.attrNames styleFiles;
          in (lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};}
            (lib.map (name: (linkStyleFile name styleFiles.${name})) names));
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
              programs.walker.config = {
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
            }
          ])
      )
    ]
  );
}
