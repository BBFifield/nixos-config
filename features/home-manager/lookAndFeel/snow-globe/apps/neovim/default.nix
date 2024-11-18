{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.snow-globe.targets.neovim;

  schemeAttrs = config.snow-globe.commonColors;

  defaultName = lib.getName config.snow-globe.defaultScheme;

  schemeNames = lib.attrNames schemeAttrs;

  unpacked = lib.listToAttrs (lib.map (schemeName: {
      name = schemeName;
      value = schemeAttrs."${schemeName}".colors;
    })
    schemeNames);

  mkColorFile = name': value: path: {
    file."${path}/${name'}.vim" = {
      text = ''
        let bg = "#${value.base00}"
        let fg = "#${value.base05}"
        let fg0 = "#${value.base0D}"
        let inactive_bg = "#${value.base02}"
        let normal_bg = "#${value.base0D}"
        let insert_bg = "#${value.base0B}"
        let visual_bg = "#${value.base0E}"
        let command_bg = "#${value.base09}"
        let replace_bg = "#${value.base0C}"
        let selection = "#${value.base02}"
        let comment = "#${value.base03}"
        let color0 = "#${value.base08}"
        let color1 = "#${value.base0E}"
        let color2 = "#${value.base0A}"
        let color3 = "#${value.base0D}"
        let color4 = "#${value.base09}"
        let color5 = "#${value.base07}"
        let color6 = "#${value.base0F}"
        let color7 = "#${value.base0E}"
        let color8 = "#${value.base0C}"
        let color9 = "#${value.base0F}"
        let color10 = "#${value.base0D}"
        let color11 = "#${value.base0F}"
        let color12 = "#${value.base0B}"
        let color13 = "#${value.base0E}"
        let menu = "#${value.base01}"
        let visual = "#${value.base05}"
        let gutter_fg = "#${value.base05}"
        let nontext = "#${value.base05}"
        let white = "#${value.base07}"
        let black = "#${value.base01}"
      '';
    };
  };
  colorFiles = {
    home = lib.mkMerge [
      (lib.foldl' (acc: item: {file = acc.file // item.file;}) {file = {};}
        (lib.attrValues (lib.mapAttrs (name: value: mkColorFile name value ".config/neocolorizer.nvim/palettes") unpacked)))
    ];
  };
in
  with lib; {
    options.snow-globe.targets.neovim = {
      enable = mkEnableOption "Enable Neovim.";
      hot-reload = lib.mkOption {
        type = (import ../../../../submodules {inherit lib;}).hot-reload;
      };
    };
    config = mkIf cfg.enable (
      lib.mkMerge [
        (lib.mkIf cfg.hot-reload.enable (lib.mkMerge [
          {
            hm.theme.hot-reload.scriptParts = lib.mkMerge [
              ''
                cp -rf "${config.home.homeDirectory}/.config/neocolorizer.nvim/palettes/$1.vim" "${config.home.homeDirectory}/.cache/neocolorizer/palette.vim"
              ''
            ];
          }
          colorFiles
        ]))
        #This file is created regardless
        {home = mkColorFile "palette" (unpacked.${defaultName}) ".cache/neocolorizer";}
      ]
    );
  }
