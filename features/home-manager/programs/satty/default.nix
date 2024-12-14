{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.satty;

  tomlFormat = pkgs.formats.toml {};
in {
  options.hm.satty = {
    enable = lib.mkEnableOption "Enable Satty, a screenshotting tool.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      satty
      slurp #For screenrecording and screenshotting
      grim #Screenshotter
    ];

    xdg.configFile."satty/config.toml" = {
      source = tomlFormat.generate "satty-config" {
        general = {
          fullscreen = false;
          # Exit directly after copy/save action
          early-exit = true;
          # Select the tool on startup [possible values: pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
          initial-tool = "brush";
          copy-command = "wl-copy";
          annotation-size-factor = 2;
          # Filename to use for saving action. Omit to disable saving to file. Might contain format specifiers: https://docs.rs/chrono/latest/chrono/format/strftime/index.html
          output-filename = "${config.home.homeDirectory}/Pictures/Screenshots/satty-%Y%m%d-%H:%M:%S.png";
          # After copying the screenshot, save it to a file as well
          save-after-copy = false;
          default-hide-toolbars = false;
          primary-highlighter = "block";
          disable-notifications = false;
        };

        # Font to use for text annotations
        font = {
          family = config.hm.theme.fonts.defaultMonospace;
          style = "Bold";
        };

        color-palette = let
          colors = config.tintednix.commonColors;
          defaultScheme = config.tintednix.defaultScheme;
        in {
          first = "#${colors.${defaultScheme}.colors.base08}";
          second = "#${colors.${defaultScheme}.colors.base09}";
          third = "#${colors.${defaultScheme}.colors.base0A}";
          fourth = "#${colors.${defaultScheme}.colors.base0B}";
          fifth = "#${colors.${defaultScheme}.colors.base0C}";
          custom = "#${colors.${defaultScheme}.colors.base0D}";
        };
      };
    };
  };
}
