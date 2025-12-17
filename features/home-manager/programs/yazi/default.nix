{
  config,
  pkgs,
  lib,
  ...
}: let
  plugins = import ./plugins.nix {inherit pkgs;};

  setWallpaper = "${import ../utilities/wallpaper/hyprpaper/setWallpaper.nix {inherit pkgs;}}/bin/set-wallpaper";
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
              (lib.foldlAttrs (acc: name: value: let
                item = plugins."${name}";
              in
                if (item?prepend_keymap)
                then (item.prepend_keymap ++ acc)
                else acc) []
              plugins)
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
            plugin = lib.foldlAttrs (acc: name: value: let
              item = plugins."${name}";
            in
              if (item?settings)
              then (item.settings // acc)
              else acc) {}
            plugins;
          }
          {
            opener = {
              set-wallpaper = lib.mkIf (config.hm.wallpaper.daemon == "hyprpaper") [
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
              edit-nvim = [
                {
                  run = ''nvim $1'';
                  for = "linux";
                  desc = "Edit in Neovim";
                  block = true;
                }
              ];
            };
            open = {
              prepend_rules = [
                {
                  mime = "image/svg+xml";
                  use = ["open" "edit-nvim"];
                }
                {
                  mime = "image/*";
                  use = ["open" "set-wallpaper" "edit-image-satty" "edit-image-gimp"];
                }
                {
                  mime = "video/*";
                  use = ["open"];
                }
              ];
            };
          }
        ];
        plugins = builtins.mapAttrs (name: _: pkgs.yaziPlugins.${name}) plugins;

        initLua = lib.foldlAttrs (acc: name: value: let
          item = plugins."${name}";
        in
          if (item?init)
          then (item.init + acc)
          else acc) ''''
        plugins;
      };
    }
  ];
}
