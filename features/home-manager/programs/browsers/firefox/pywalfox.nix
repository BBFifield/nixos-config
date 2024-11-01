{
  config,
  lib,
  pkgs,
  ...
}: let
  profilesPath = ".mozilla/firefox";
  directory = "${config.home.homeDirectory}/.cache/wal";

  jsonFormat = pkgs.formats.json {};

  attrset = import ../../../themes/colorschemeInfo.nix;
  themeNames = lib.attrNames attrset;
  getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

  defaultTheme = config.hm.theme.colorscheme.name;
  defaultVariant = config.hm.theme.colorscheme.variant;

  unpacked = lib.listToAttrs (lib.concatMap (theme:
    lib.map (variant: {
      name = "${theme}_${variant}";
      value = attrset.${theme}.cognates variant;
    }) (getVariantNames theme))
  themeNames);

  mkColorFile = name': value: path: {
    home.file.".cache/wal/${path}${name'}.json" = {
      source = jsonFormat.generate "${name'}" {
        wallpaper = "/home/brandon/Pictures/wallpapers/Bing/OHR.BeachHutsSweden_DE-DE4614841617_1920x1080.jpg";
        name = name';
        colors = {
          #BackgroundLight and BackgroundExtra in dark mode depend on Background
          base00 = "#${value.bg_alt}"; #dark:Background, light:Text Focus
          base01 = "";
          base02 = "";
          base03 = "#${value.accent_primary_alt}"; #light:Accent Primary
          base04 = "";
          base05 = "#${value.accent_secondary_alt}"; #light:Accent Secondary
          base06 = "";
          base07 = "#${value.btn_hover_bg}"; #light:Background Extra
          base08 = "";
          base09 = "";
          base10 = "#${value.text_alt}"; #dark:Accent Primary, light:Background
          base11 = "";
          base12 = "";
          base13 = "#${value.color_slot2}"; #dark:Accent Secondary
          base14 = "";
          base15 = "#${value.text_alt}"; #dark:Text
        };
      };
    };
  };

  colorFiles =
    lib.foldl' (acc: item: {home.file = acc.home.file // item.home.file;}) {home.file = {};} (lib.attrValues (lib.mapAttrs (name: value: mkColorFile name value "pywalfox_colorschemes/") unpacked));
in {
  options.hm.firefox.pywalfox = {
    enable = lib.mkEnableOption "Enable pywalfox, a dynamic firefox colorscheme client.";
  };
  config = lib.mkIf (config.hm.firefox.pywalfox.enable) (
    lib.mkMerge [
      #This file is created regardless
      (mkColorFile "colors" (attrset.${defaultTheme}.cognates defaultVariant) "")
      {
        programs.firefox = {
          profiles.default.extensions = [pkgs.nur.repos.rycee.firefox-addons.pywalfox];
        };
        home.activation.pywalfox = lib.hm.dag.entryAfter ["writeBoundary"] ''
          if ! test -f "${config.home.homeDirectory}/.mozilla/native-messaging-hosts/pywalfox.json"; then
            ${pkgs.pywalfox-native}/bin/pywalfox install
          fi
          ${pkgs.pywalfox-native}/bin/pywalfox start
          ${pkgs.pywalfox-native}/bin/pywalfox update
          ${pkgs.pywalfox-native}/bin/pywalfox ${attrset.${defaultTheme}.variants.${defaultVariant}.mode}
        '';

        home.packages = with pkgs; [
          pywalfox-native
          python3
        ];
      }
      (lib.mkIf config.hm.firefox.hot-reload.enable (lib.mkMerge [
        {
          hm.theme.hot-reload.scriptParts = lib.mkMerge [
            (lib.mkOrder 30 ''
              cp -rf "${directory}/pywalfox_colorschemes/$1.json" "${directory}/colors.json"
            '')
            (lib.mkOrder 50 ''
              pywalfox $mode
              pywalfox update
            '')
          ];
        }
        colorFiles
      ]))
    ]
  );
}
