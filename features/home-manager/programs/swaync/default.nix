{
  config,
  lib,
  pkgs,
  ...
}: let
  swayncClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";

  imports = "${pkgs.tintednix.root}/pkgs/themes/gtk/base16-gtk";
  compiledSassFile =
    pkgs.runCommand "style_swaync" {nativeBuildInputs = with pkgs; [dart-sass jq];}
    ''
      #!/usr/bin/env bash
      set -euo pipefail
      sass --load-path="${imports}" "${./config/style.scss}" "$out/.config/swaync/style.css"
    '';
in {
  options.hm.swaync = {
    enable = lib.mkEnableOption "Enable swaync support";
  };

  config = lib.mkIf config.hm.swaync.enable {
    home.packages = [compiledSassFile];
    xdg.configFile."swaync/style.css" = {
      source = "${compiledSassFile}/.config/swaync/style.css";
      onChange = ''
        if ${pkgs.systemd}/bin/systemctl --user is-active swaync.service; then
          ${swayncClient} -rs
        fi
      '';
    };

    services.swaync = {
      enable = true;
      settings = {
        cssPriority = "user";
        ignore-gtk-theme = false;
        image-visibility = "when-available";
        positionX = "center";
        positionY = "top";
        fit-to-screen = false;
        control-center-height = -1;
        widgets = [
          "mpris"
          "dnd"
          "notifications"
          "title"
        ];
        widget-config = {
          mpris = {
            autohide = false;
            show-album-art = "always";
            loop-carousel = true;
          };
          dnd = {
            text = "Do Not Disturb";
          };
          notifications = {
            vexpand = false;
          };
          title = {
            text = "";
            clear-all-button = true;
            button-text = "Clear All";
          };
          label = {
            max-lines = 5;
            text = "Label Text";
          };
        };
      };
    };
  };
}
