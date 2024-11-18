{
  config,
  pkgs,
  lib,
  ...
}: let
  family = "JetBrainsMono Nerd Font";
  cfg = config.hm.alacritty;
  tomlFormat = pkgs.formats.toml {};

  settings = {
    font = {
      size = 11.0;
      bold = {
        inherit family;
        style = "Bold";
      };
      bold_italic = {
        inherit family;
        style = "Bold Italic";
      };
      italic = {
        inherit family;
        style = "Italic";
      };
      normal = {
        inherit family;
        style = "Regular";
      };
    };
    window = {
      opacity = 0.9;
    };
  };
in {
  options.hm.alacritty = {
  };
  config = lib.mkMerge [
    {
      programs.alacritty = {
        enable = true;
        settings = lib.mkMerge [
          {
            import = ["${config.home.homeDirectory}/.config/alacritty/alacritty-theme.toml"];
          }
          settings
        ];
      };
    }
  ];
}
