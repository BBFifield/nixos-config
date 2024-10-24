{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.ironbar;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  options.hm.ironbar = {
    enable = lib.mkEnableOption "Enable ironbar statusbar.";
    hotload = lib.mkOption {
      type = (import ../../../submodules {inherit lib;}).hotload;
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
      /*
        (
        lib.mkIf (config.hm.enableMutableConfigs && !config.hm.hotload.enable) {
          xdg.configFile."ironbar".source = mkOutOfStoreSymlink "${config.hm.projectPath}/bars/ironbar/config";
        }
      )
      */
      (
        lib.mkIf (config.hm.ironbar.hotload.enable) (let
          attrset = import ../../../themes/colorschemeInfo.nix;
          themeNames = lib.attrNames attrset;
          getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

          mkColorPrefix = name: value: {
            name = "\$${name}";
            value = "#${value}";
          };

          unpacked = lib.concatMap (theme:
            lib.map (variant: {
              name = "${theme}_${variant}";
              value = let
                cognates = attrset.${theme}.cognates variant;
              in
                lib.map (cognateName: mkColorPrefix cognateName cognates.${cognateName}) (lib.attrNames cognates);
            }) (getVariantNames theme))
          themeNames;

          mkColorsFile = value:
            pkgs.writeTextFile {
              name = "_ironbar_colors.scss";
              text = lib.concatStringsSep "\n" (lib.map (cognate: "${cognate.name}: ${cognate.value};") value);
            };

          mkStyleFile = name: value: installPhase:
            pkgs.runCommand name {nativeBuildInputs = with pkgs; [dart-sass];} ''
              #!/usr/bin/env bash
              mkdir -p $out
              cp -rf "${mkColorsFile value}" "$out/_ironbar_colors.scss"
              cp -rf "${./config/style.scss}" "$out/style.scss"
              ${installPhase}
            '';

          initialStyleFile = let
            name = "${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}";
          in
            mkStyleFile name (lib.head (lib.filter (theme: name == theme.name) unpacked)).value ''
              sass "$out/style.scss" "$out/.config/ironbar/style.css"
            '';

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
              hm.hotload.scriptParts = {
                "3" = ''
                  rm "$directory/ironbar/style.css"
                  cp -rf "$directory/ironbar/ironbar_colorschemes/$1.css" "$directory/ironbar/style.css"
                '';
                "9" = ''
                  ironbar load-css "$directory/ironbar/style.css"
                '';
              };

              home.packages =
                [initialStyleFile]
                ++ lib.attrValues styleFiles;

              xdg.configFile."ironbar/style.css".source = "${initialStyleFile}/.config/ironbar/style.css";
              xdg.configFile."ironbar/config.corn".source = ./config/config.corn;
              xdg.configFile."ironbar/sys_info.sh".source = ./config/sys_info.sh;
            }
            linkedStyleFiles
          ])
      )
    ]
  );
}
