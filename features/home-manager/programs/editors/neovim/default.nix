{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.neovim;

  attrset = import ../../../lookAndFeel/colorschemeInfo.nix;
  themeNames = lib.attrNames attrset;
  getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

  defaultTheme = config.hm.theme.colorscheme.name;
  defaultVariant = config.hm.theme.colorscheme.variant;

  unpacked = lib.listToAttrs (lib.concatMap (theme:
    lib.map (variant: {
      name = "${theme}_${variant}";
      value = attrset.${theme}.cognates variant;
    }) (getVariantNames theme))
  themeNames);

  mkColorFile = name': value: path: {
    home.file."${path}/${name'}.vim" = {
      text = ''
        let bg = "#${value.bg}"
        let fg = "#${value.text}"
        let fg0 = "#${value.fg}"
        let inactive_bg = "#${value.fg_field}"
        let normal_bg = "#${value.btn_hover_bg}"
        let insert_bg = "#${value.btn_hover_bg2}"
        let visual_bg = "#${value.btn_hover_bg3}"
        let command_bg = "#${value.btn_hover_bg4}"
        let replace_bg = "#${value.btn_hover_bg5}"
        let selection = "#${value.selection}"
        let comment = "#${value.comment}"
        let color0 = "#${value.color0}"
        let color1 = "#${value.color1}"
        let color2 = "#${value.color2}"
        let color3 = "#${value.color3}"
        let color4 = "#${value.color4}"
        let color5 = "#${value.color5}"
        let color6 = "#${value.color6}"
        let color7 = "#${value.color7}"
        let color8 = "#${value.color8}"
        let color9 = "#${value.color9}"
        let color10 = "#${value.color10}"
        let color11 = "#${value.color11}"
        let color12 = "#${value.color12}"
        let color13 = "#${value.color13}"
        let menu = "#${value.menu}"
        let visual = "#${value.nontext}"
        let gutter_fg = "#${value.nontext}"
        let nontext = "#${value.nontext}"
        let white = "#${value.white}"
        let black = "#${value.black}"
      '';
    };
  };

  colorFiles =
    lib.foldl' (acc: item: {home.file = acc.home.file // item.home.file;}) {home.file = {};} (lib.attrValues (lib.mapAttrs (name: value: mkColorFile name value ".config/neocolorizer.nvim/palettes") unpacked));
in
  with lib; {
    options.hm.neovim = {
      enable = mkEnableOption "Enable Neovim.";
      pluginManager = mkOption {
        type = with types; nullOr (enum ["lazy" "nix"]);
        default = null;
        description = ''
          Which package manager to use to manage your neovim plugins.
        '';
      };
      hot-reload = lib.mkOption {
        type = (import ../../../submodules {inherit lib;}).hot-reload;
      };
    };
    config = mkIf cfg.enable (
      lib.mkMerge [
        {
          programs.neovim = {
            enable = true;
            defaultEditor = true;
          };
          home.packages = with pkgs; [
            wl-clipboard # For system clipboard capabilities
            ripgrep # For BurntSushi/ripgrep
            gcc # For installing treesitter parsers
          ];

          xdg.configFile."nvim" = {
            source = ./lazy;
            recursive = true;
          };
        }
        (lib.mkIf config.hm.neovim.hot-reload.enable (lib.mkMerge [
          {
            hm.theme.hot-reload.scriptParts = lib.mkMerge [
              (lib.mkOrder 33 ''
                cp -rf "${config.home.homeDirectory}/.config/neocolorizer.nvim/palettes/$1.vim" "${config.home.homeDirectory}/.cache/neocolorizer/palette.vim"
              '')
            ];
          }
          colorFiles
        ]))
        #This file is created regardless
        (mkColorFile "palette" (attrset.${defaultTheme}.cognates defaultVariant) ".cache/neocolorizer")
      ]
    );
  }
