{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.ironbar;

  attrset = import ../../../lookAndFeel/colorschemeInfo.nix;

  mkColorPrefix = name: value: {
    name = "\$${name}";
    value = "#${value}";
  };

  mkColorsFile = value:
    pkgs.writeTextFile {
      name = "_ironbar_colors.scss";
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
      cp -rf "${mkColorsFile value}" "$out/_ironbar_colors.scss"
      cp -rf "${./config/style.scss}" "$out/style.scss"
      ${installPhase}
    '';

  initialStyleFile = let
    name = config.hm.theme.colorscheme.name;
    variant = config.hm.theme.colorscheme.variant;
  in
    mkStyleFile "${name}_${variant}" (mkCognateList name variant) ''
      sass "$out/style.scss" "$out/.config/ironbar/style.css"
    '';
in {
  options.hm.ironbar = {
    enable = lib.mkEnableOption "Enable ironbar statusbar.";
    hot-reload = lib.mkOption {
      type = (import ../../../submodules {inherit lib;}).hot-reload;
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
          config = "";
          style = "";
        };
      }
      {
        home.packages = [initialStyleFile];
        xdg.configFile."ironbar/style.css" = {
          source = "${initialStyleFile}/.config/ironbar/style.css";
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
        lib.mkIf (!config.hm.hot-reload.enable) {
          xdg.configFile."ironbar" = {
            source = ./config;
            recursive = true;
          };
        }
      )

      (
        lib.mkIf (config.hm.ironbar.hot-reload.enable) (let
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
              sass "$out/style.scss" "$out/.config/ironbar/ironbar_colorschemes/${name}.css"
              rm "$out/_ironbar_colors.scss"
            '')
          (lib.listToAttrs unpacked);

          linkStyleFile = name: value: {
            xdg.configFile."ironbar/ironbar_colorschemes/${name}.css".source = "${value}/.config/ironbar/ironbar_colorschemes/${name}.css";
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
