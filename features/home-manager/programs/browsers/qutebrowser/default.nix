{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.browsers.qutebrowser;
in {
  options.hm.browsers.qutebrowser = {
    enable = lib.mkEnableOption "Enable qutebrowser.";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [python313Packages.adblock];
    programs.qutebrowser = {
      enable = true;
      extraConfig = ''
        config.source('colors.py')
        c.fonts.default_family = "${config.hm.theme.fonts.defaultMonospace}"
        c.fonts.default_size = '11pt'
        c.qt.highdpi = True
        c.statusbar.position = 'top'
        c.statusbar.padding = {'top': 2, 'bottom': 2, 'left': 0, 'right': 0}
        c.tabs.padding = {'top': 4, 'bottom': 4, 'left': 0, 'right': 0}

        c.colors.webpage.darkmode.enabled = True
        c.colors.webpage.preferred_color_scheme = 'dark'

        c.content.autoplay = False
        c.scrolling.smooth = False

        config.set('content.headers.user_agent',
           'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
           'accounts.google.com')

      '';
      keyBindings = {
        normal = {
          ",m" = "spawn umpv {url}";
          ",M" = "hint links spawn umpv {hint-url}";
          ";M" = "hint --rapid links spawn umpv {hint-url}";
        };
      };
      searchEngines = let
        seAttrs = import ../searchEngines.nix {inherit pkgs;};

        seComposedList = builtins.attrValues (builtins.mapAttrs (name: value: let
            url = builtins.head value.urls;
            alias = lib.removePrefix "@" (builtins.head value.definedAliases);
          in {
            name = alias;
            value = lib.foldr (nextParam: accu: let
              nextParamVal =
                if (nextParam.value == "{searchTerms}")
                then "{}"
                else nextParam.value;
            in
              accu + "?" + nextParam.name + "=" + nextParamVal) "${url.template}"
            url.params;
          })
          seAttrs.custom);

        searchEngines = lib.listToAttrs seComposedList;
      in
        searchEngines
        // {
          g = "https://www.google.com/search?hl=en&q={}";
        };
    };
  };
}
/*
https://qutebrowser.org/doc/quickstart.html
- Open new URLs by pressing o, typing the address, and hitting Enter.
- Use O to open in a new tab.
- Close the current tab with d and undo with u, and use H and L to go back and forth through history
*/

