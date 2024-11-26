{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.yazi;
  tomlFormat = pkgs.formats.toml {};
  /*
    flavorPaths = [
    {
      url = "https://github.com/yazi-rs/flavors.git";
      ref = "main";
      rev = "1f54993b7a3f4b9c551531e019d82c7a609c6cd0";
    }
    {
      url = "https://github.com/bennyyip/gruvbox-dark.yazi.git";
      name = "gruvbox-dark.yazi";
      ref = "main";
      rev = "c204853de7a78bc99ea628e51857ce65506468db";
    }
  ];

  attrset = import ../../lookAndFeel/colorschemeInfo.nix;
  themeNames = lib.attrNames attrset;
  getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

  queryGit = theme: variant:
    lib.foldl' (acc: x:
      if (x != null)
      then x
      else acc) {} (lib.map (path:
      if (lib.hasInfix "${theme}-${variant}.yazi" path.url)
      then "${builtins.fetchGit path}"
      else
        (
          if (builtins.pathExists "${builtins.fetchGit path}/${theme}-${variant}.yazi")
          then "${builtins.fetchGit path}/${theme}-${variant}.yazi"
          else null
        ))
    flavorPaths);

  mkThemeFileIfHasPath = theme: variant: path:
    if (queryGit theme variant) != {}
    then mkThemeFile theme variant path
    else null;

  mkThemeFile = theme: variant: path: {
    xdg.configFile."${path}.toml" = {
      source = tomlFormat.generate "theme" {
        flavor = {
          use = "${theme}-${variant}";
        };
      };
    };
  };

  defaultTheme = config.hm.theme.colorscheme.name;
  defaultVariant = config.hm.theme.colorscheme.variant;

  defaultThemeHasPath = queryGit defaultTheme defaultVariant;
  */
in {
  options.hm.yazi = {
    enable = lib.mkEnableOption "Enable Yazi, the terminal file manager.";
    live = lib.mkOption {
      type = (import ../../submodules {inherit lib;}).live;
    };
  };

  config = lib.mkMerge [
    /*
      (
      lib.mkIf (cfg.live.enable)
      (
        let
          themeFilesList = lib.filter (item: item != null) (lib.concatMap (theme:
            lib.map (
              variant: let
                file = mkThemeFileIfHasPath theme variant "yazi/themes/${theme}_${variant}";
              in
                file
            ) (getVariantNames theme))
          themeNames);

          mkthemeFiles = lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} themeFilesList;
        in
          lib.mkMerge [
            {
              hm.theme.live.hooks = lib.mkMerge [
                (lib.mkOrder 25 ''
                  rm $directory/yazi/theme.toml
                  cp -rf $directory/yazi/themes/$1.toml $directory/yazi/theme.toml
                '')
              ];
            }
            mkthemeFiles
          ]
      )
    )
    */
    #This is the default file created regardless of liveing being enabled
    /*
      (
      lib.mkIf (defaultThemeHasPath != {}) (mkThemeFile defaultTheme defaultVariant "yazi/theme")
    )
    */
    #This ensures no theme is left over from a previous generation
    /*
      (
      lib.mkIf (defaultThemeHasPath == {}) {
        home.activation.yazi = lib.hm.dag.entryAfter ["writeBoundary"] ''
          if test -f "${config.home.homeDirectory}/.config/yazi/theme.toml"; then
            rm "${config.home.homeDirectory}/.config/yazi/theme.toml"
          fi
        '';
      }
    )
    */
    {
      home.packages = with pkgs; [
        ueberzugpp
      ];
      programs.yazi = let
        pluginPaths = [
          {
            url = "https://github.com/Rolv-Apneseth/starship.yazi.git";
            ref = "main";
            rev = "77a65f5a367f833ad5e6687261494044006de9c3";
          }
        ];
      in {
        enable = true;
        enableBashIntegration = true;
        /*
          flavors = lib.mkMerge [
          (lib.mkIf (config.hm.yazi.live.enable) (
            lib.listToAttrs (lib.filter (item: item != null) (lib.concatMap (theme:
              lib.map (
                variant: let
                  path = queryGit theme variant;
                  flavor =
                    if (path != {})
                    then {
                      name = "${theme}-${variant}";
                      value = path;
                    }
                    else null;
                in
                  flavor
              ) (getVariantNames theme))
            themeNames))
          ))

          (lib.mkIf (!config.hm.yazi.live.enable) (
            let
              path = queryGit defaultTheme defaultVariant;
              flavor =
                if (path != {})
                then {
                  name = "${defaultTheme}-${defaultVariant}";
                  value = path;
                }
                else null;
            in
              flavor
          ))
        ];
        */

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
                        ui.Bar(self._chunks[1], ui.Bar.RIGHT):style(style),
                        ui.Bar(self._chunks[3], ui.Bar.LEFT):style(style),

                        bar("┬", c[1].right - 1, c[1].y),
                        bar("┴", c[1].right - 1, c[1].bottom - 1),
                        bar("┬", c[2].right, c[2].y),
                        bar("┴", c[2].right, c[1].bottom - 1),
                    })

                    old_build(self, ...)
                end
              ''
            ]));
      };
    }
  ];
}
