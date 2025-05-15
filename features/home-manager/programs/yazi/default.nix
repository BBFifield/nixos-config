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
            rev = "6c639b474aabb17f5fecce18a4c97bf90b016512";
          }
          {
            url = "https://github.com/DreamMaoMao/keyjump.yazi.git";
            ref = "main";
            rev = "4fb2bc3ae51993c7196b32bc781b5c5d0ae1e437";
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
                run = "plugin keyjump keep";
                desc = "Keyjump (Keep mode)";
              }
              {
                on = ["i"];
                run = "plugin keyjump";
                desc = "Keyjump (Normal mode)";
              }
              {
                on = ["i"];
                run = "plugin keyjump select";
                desc = "Keyjump (Select mode)";
              }
              {
                on = ["i"];
                run = "plugin keyjump global";
                desc = "Keyjump (Global mode)";
              }
              {
                on = ["i"];
                run = "plugin keyjump 'global once'";
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
                      return ui.Bar(ui.Bar.TOP):area(ui.Rect.default)
                    end

                    return ui.Bar(ui.Bar.TOP)
                      :area(ui.Rect({
                        x = x,
                        y = math.max(0, y),
                        w = ya.clamp(0, self._area.w - x, 1),
                        h = math.min(1, self._area.h),
                      }))
                      :symbol(c)
                  end

                  local c = self._chunks
                  self._chunks = {
                    c[1]:pad(ui.Pad.y(1)),
                    c[2]:pad(ui.Pad(1, c[3].w > 0 and 0 or 1, 1, c[1].w > 0 and 0 or 1)),
                    c[3]:pad(ui.Pad.y(1)),
                  }

                  local style = th.mgr.border_style
                  self._base = ya.list_merge(self._base or {}, {
                    ui.Bar(ui.Bar.RIGHT):area(self._chunks[1]):style(style),
                    ui.Bar(ui.Bar.LEFT):area(self._chunks[1]):style(style),

                    bar("┬", c[1].right - 1, c[1].y),
                    bar("┴", c[1].right - 1, c[1].bottom - 1),
                    bar("┬", c[2].right, c[2].y),
                    bar("┴", c[2].right, c[2].bottom - 1),
                  })

                  old_build(self, ...)
                end
              ''
            ]));
      };
    }
  ];
}
