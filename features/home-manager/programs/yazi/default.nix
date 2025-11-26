{
  config,
  pkgs,
  lib,
  ...
}: let
  plugins = import ./plugins.nix {inherit pkgs;};

  setWallpaper = "${import ../wallpaper/hyprpaper/setWallpaper.nix {inherit pkgs;}}/bin/apply-wallpaper";
in {
  imports = [./filechooser.nix];

  options.hm.yazi = {
    enable = lib.mkEnableOption "Enable Yazi, the terminal file manager.";
  };

  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        ueberzugpp
        trash-cli # for recycle-bin plugin
        mediainfo # for mediainfo plugin
        imagemagick # for mediainfo plugin
        ouch # for ouch plugin
        dragon-drop # for drag and drop
      ];
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        keymap = {
          mgr = {
            prepend_keymap =
              builtins.concatLists (lib.mapAttrsToList (name: value: value.prepend_keymap) plugins)
              ++ [
                {
                  on = "!";
                  for = "unix";
                  run = ''shell "$SHELL" --block'';
                  desc = "Open $SHELL here";
                }
                {
                  on = "<C-n>";
                  run = ''shell -- dragon -x -i -T "$0"'';
                  desc = "Drag and drop";
                }
                {
                  on = ["g" "r"];
                  run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
                  desc = "Go to top-level of git repo";
                }
                {
                  on = "y";
                  run = [''shell -- for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list'' "yank"];
                  desc = "Copy selected files to the system clipboard while yanking";
                }
              ];
          };
        };
        theme = (import ./theme.nix {}).theme;
        settings = lib.mkMerge [
          {
            mgr = {
              show_hidden = true;
            };
            plugin = {
              prepend_preloaders =
                builtins.concatLists (lib.mapAttrsToList (name: value: value.settings.prepend_preloaders) plugins);
              prepend_previewers =
                builtins.concatLists (lib.mapAttrsToList (name: value: value.settings.prepend_previewers) plugins);
            };
          }
          (lib.mkIf (config.hm.wallpaper.daemon == "hyprpaper") {
            opener = {
              set-wallpaper = [
                {
                  run = ''${setWallpaper} $1'';
                  for = "linux";
                  desc = "Set as wallpaper 󰸉";
                }
              ];
              edit-image-satty = [
                {
                  run = ''satty --filename $1'';
                  for = "linux";
                  desc = "Edit image with Satty 󱇣";
                }
              ];
              edit-image-gimp = [
                {
                  run = ''gimp -s $1'';
                  for = "linux";
                  desc = "Edit image with GIMP 󱇣";
                }
              ];
            };
            open = {
              prepend_rules = [
                {
                  mime = "image/*";
                  use = ["open" "set-wallpaper" "edit-image-satty" "edit-image-gimp"];
                }
              ];
            };
          })
        ];
        plugins = builtins.mapAttrs (name: _: pkgs.yaziPlugins.${name}) plugins;

        initLua = lib.concatStrings (lib.mapAttrsToList (name: value: value.init) plugins);
      };
    }
  ];
}
