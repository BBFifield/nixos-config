{
  config,
  pkgs,
  lib,
  ...
}: let
  walker = "${config.programs.walker.package}/bin/walker";

  imports = "${pkgs.tintednix.root}/pkgs/themes/gtk/base16-gtk";
  compiledSassFile =
    pkgs.runCommand "style_walker" {nativeBuildInputs = with pkgs; [dart-sass jq];}
    ''
      #!/usr/bin/env bash
      set -euo pipefail
      sass --load-path="${imports}" "${./config/style.scss}" "$out/.config/walker/themes/style/style.css"
    '';
in {
  # imports = [./elephant];

  options.hm.walker = {
    enable = lib.mkEnableOption "Enable Walker launcher.";
    width = lib.mkOption {
      type = lib.types.int;
      default = 600;
    };
    height = lib.mkOption {
      type = lib.types.int;
      default = 600;
    };
  };

  config = lib.mkIf config.hm.walker.enable (
    lib.mkMerge [
      {
        # xdg.configFile = {
        #   "elephant/menus/tintednix.toml".source =
        #     (pkgs.formats.toml {}).generate "tintednix.toml"
        #     {
        #       name = "color scheme";
        #       name_pretty = "Color Scheme";
        #       action = "tintednix --update %VALUE%";
        #       entries = let
        #         entries =
        #           lib.mapAttrsToList (schemeName: schemeValue: {
        #             text = "${schemeName}";
        #             # value = "tintednix --update ${schemeName} ${schemeValue.variant}";
        #             value = "${schemeName}";
        #           })
        #           config.hm.tintednix.schemeVariantAndColors;
        #       in
        #         entries;
        #     };
        # "elephant/menus/wallpapers.toml".source =
        #   (pkgs.formats.toml {}).generate "wallpapers.toml"
        #   {
        #     name = "wallpapers";
        #     name_pretty = "Wallpapers";
        #     icon = "applications-other";
        #     lua = "fetch_wallpapers";
        #     lua_cache = true;
        #     action = "notify-send %VALUE%";
        #   };
        # "elephant/menus/fetch_wallpapers.lua".source = import ./elephant/fetch_wallpapers.nix {inherit config pkgs;};
        # };
        # {
        #   name = "bookmarks";
        #   name_pretty = "Bookmarks";
        #   icon = "bookmark";
        #   action = "xdg-open %VALUE%";
        #   entries = let
        #     customEngines = (import ../browsers/search-engines.nix {inherit pkgs;}).custom;
        #     entriesList =
        #       lib.mapAttrsToList (name': value: {
        #         text = lib.toSentenceCase name';
        #         value = let
        #           urlParts = lib.head value.urls;
        #           template = urlParts.template;
        #           params = urlParts.params;
        #           paramsString = lib.foldl (acc: paramParts: let
        #             param = let
        #               index = lib.lists.findFirstIndex (x: x.name == paramParts.name && x.value == paramParts.value) null params;
        #               nextPrefix =
        #                 if (index == ((lib.length params) - 1))
        #                 then ""
        #                 else "&";
        #               value =
        #                 if paramParts.value == "{searchTerms}"
        #                 then "%TERM%"
        #                 else paramParts.value;
        #             in
        #               paramParts.name + "=" + value + nextPrefix;
        #           in
        #             acc + param) "?"
        #           params;
        #         in
        #           template + paramsString;
        #         prefix = lib.head value.definedAliases;
        #         # image = value.icon;
        #       })
        #       customEngines;
        #   in
        #     entriesList;
        # }
      }
      {
        programs.walker = {
          enable = true;
          runAsService = false;
          config = lib.trivial.importTOML ./config/config.toml;
          # {
          #   app_launch_prefix = "uwsm app -- ";
          #   terminal = "alacritty";
          #   hotreload_theme = true;
          #   theme = "style";
          #   as_window = true;
          #   close_when_open = true;
          #   disable_click_to_close = false;
          #   ignore_mouse = true;
          #   builtins.websearch = {
          #     # Some reason the second param doesn't get used by walker even if it's in the config
          #     entries = let
          #       customEngines = (import ../browsers/search-engines.nix {inherit pkgs;}).custom;
          #       entriesList =
          #         lib.mapAttrsToList (name': value: {
          #           name = lib.toSentenceCase name';
          #           url = let
          #             urlParts = lib.head value.urls;
          #             template = urlParts.template;
          #             params = urlParts.params;
          #             paramsString = lib.foldl (acc: paramParts: let
          #               param = let
          #                 index = lib.lists.findFirstIndex (x: x.name == paramParts.name && x.value == paramParts.value) null params;
          #                 nextPrefix =
          #                   if (index == ((lib.length params) - 1))
          #                   then ""
          #                   else "&";
          #                 value =
          #                   if paramParts.value == "{searchTerms}"
          #                   then "%TERM%"
          #                   else paramParts.value;
          #               in
          #                 paramParts.name + "=" + value + nextPrefix;
          #             in
          #               acc + param) "?"
          #             params;
          #           in
          #             template + paramsString;
          #           prefix = lib.head value.definedAliases;
          #           # image = value.icon;
          #         })
          #         customEngines;
          #     in
          #       entriesList;
          #   };
          #   builtins.switcher.prefix = "/";
          #   custom_commands = {
          #     "name" = "commands";
          #     "prefix" = "!";
          #   };
          #   plugins = [
          #     {
          #       "name" = "power";
          #       "placeholder" = "Power";
          #       "show_icon_when_single" = true;
          #       "entries" = [
          #         {
          #           "label" = "Shutdown";
          #           "icon" = "system-shutdown";
          #           "exec" = "shutdown now";
          #         }
          #         {
          #           "label" = "Reboot";
          #           "icon" = "system-reboot";
          #           "exec" = "reboot";
          #         }
          #         {
          #           "label" = "Lock Screen";
          #           "icon" = "system-lock-screen";
          #           "exec" = "playerctl --all-players pause & pidof hyprlock || hyprlock";
          #         }
          #       ];
          #     }
          #     {
          #       "name" = "color scheme";
          #       "placeholder" = "Color Scheme";
          #       "prefix" = "$";
          #       "switcher_only" = true;
          #       "recalculate_score" = false;
          #       "show_icon_when_single" = true;
          #       "entries" = let
          #         entries =
          #           lib.mapAttrsToList (schemeName: schemeValue: {
          #             "label" = "${schemeName}";
          #             "exec" = "tintednix update ${schemeName} ${schemeValue.variant}";
          #           })
          #           config.hm.tintednix.schemeVariantAndColors;
          #       in
          #         entries;
          #     }
          #     {
          #       name = "wallpapers";
          #       prefix = "#";
          #       src_once = "node ${./config/fetch_wallpapers.cjs}";
          #       parser = "kv";
          #       recalculate_score = false;
          #       refresh = true;
          #       show_icon_when_single = true;
          #       switcher_only = true;
          #     }
          #   ];
          # };
        };
      }
      {
        home.packages = [compiledSassFile];
        xdg.configFile."walker/themes/style/style.css" = {
          source = "${compiledSassFile}/.config/walker/themes/style/style.css";
          # source = ./config/style.css;
          onChange = ''
            if ${pkgs.systemd}/bin/systemctl --user is-active walker.service; then
              ${walker} --theme style
            fi
          '';
        };
        xdg.configFile."walker/themes/style/layout.xml".source = ./config/layout.xml;
      }
    ]
  );
}
