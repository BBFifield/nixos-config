{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.yazi;
in {
  options.hm.yazi = {
    enable = lib.mkEnableOption "Enable Yazi, the terminal file manager.";
    live = lib.mkOption {
      type = (import ../../submodules {inherit lib;}).live;
    };
  };

  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        ueberzugpp
      ];
      programs.yazi = let
        pluginPaths = [
          {
            url = "https://github.com/Rolv-Apneseth/starship.yazi.git";
            ref = "main";
            rev = "247f49da1c408235202848c0897289ed51b69343";
          }
          {
            url = "https://github.com/DreamMaoMao/keyjump.yazi.git";
            ref = "main";
            rev = "9ba4cfae2f6cc45bfaa543409af91de41cb1e825";
          }
        ];
      in {
        enable = true;
        enableBashIntegration = true;
        keymap = {
          manager = {
            prepend_keymap = [
              {
                on = ["i"];
                run = "plugin keyjump --args=keep";
                desc = "Keyjump (Keep mode)";
              }
              {
                on = ["i"];
                run = "plugin keyjump";
                desc = "Keyjump (Normal mode)";
              }
              {
                on = ["i"];
                run = "plugin keyjump --args=select";
                desc = "Keyjump (Select mode)";
              }
              {
                on = ["i"];
                run = "plugin keyjump --args=global";
                desc = "Keyjump (Global mode)";
              }
              {
                on = ["i"];
                run = "plugin keyjump --args='global once'";
                desc = "Keyjump (once Global mode)";
              }
            ];
          };
        };
        theme = (import ./theme.nix {}).theme;
        settings = {
          manager = {
            show_hidden = true;
          };
        };
        plugins = let
          plugins' = lib.listToAttrs (lib.map (path: {
              name = let
                name = lib.removePrefix "https://github.com/" (lib.removeSuffix ".yazi" (lib.removeSuffix ".git" path.url));
              in
                name;
              value = builtins.fetchGit path;
            })
            pluginPaths);
        in
          plugins';

        initLua = let
          requireStrings = lib.map (path: let
            name = lib.removePrefix "https://github.com/" (lib.removeSuffix ".yazi" (lib.removeSuffix ".git" path.url));
          in ''require("${name}"):setup()'')
          pluginPaths;
        in
          (lib.mkIf (config.hm.starship.enable)) (lib.concatLines (requireStrings
            ++ [
              ''
                local old_build = Tab.build
                Tab.build = function(self, ...)
                    local bar = function(c, x, y)
                        if x <= 0 or x == self._area.w - 1 then
                            return ui.Bar(ui.Rect.default, ui.Bar.TOP)
                        end

                        return ui.Bar(
                            ui.Rect({
                                x = x,
                                y = math.max(0, y),
                                w = ya.clamp(0, self._area.w - x, 1),
                                h = math.min(1, self._area.h),
                            }),
                            ui.Bar.TOP
                        ):symbol(c)
                    end

                    local c = self._chunks
                    self._chunks = {
                        c[1]:padding(ui.Padding.y(1)),
                        c[2]:padding(ui.Padding(c[1].w > 0 and 0 or 1, c[3].w > 0 and 0 or 1, 1, 1)),
                        c[3]:padding(ui.Padding.y(1)),
                    }

                    local style = THEME.manager.border_style
                    self._base = ya.list_merge(self._base or {}, {
                        -- Enable for full border
                        --[[ ui.Border(self._area, ui.Border.ALL):type(ui.Border.ROUNDED):style(style), ]]
                        --ui.Bar(self._chunks[1], ui.Bar.RIGHT):style(style),
                        --ui.Bar(self._chunks[3], ui.Bar.LEFT):style(style),

                        --bar("┬", c[1].right - 1, c[1].y),
                        --bar("┴", c[1].right - 1, c[1].bottom - 1),
                        --bar("┬", c[2].right, c[2].y),
                        --bar("┴", c[2].right, c[1].bottom - 1),
                    })

                    old_build(self, ...)
                end
              ''
            ]));
      };
    }
  ];
}
