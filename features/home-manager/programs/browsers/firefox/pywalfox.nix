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

  unpacked = lib.listToAttrs (lib.concatMap (theme:
    lib.map (variant: {
      name = "${theme}_${variant}";
      value = attrset.${theme}.cognates variant;
    }) (getVariantNames theme))
  themeNames);

  mkColorFile = name': value: {
    home.file.".cache/wal/pywalfox_colorschemes/${name'}.json".source = jsonFormat.generate "${name'}" {
      wallpaper = "/home/brandon/Pictures/wallpapers/Bing/OHR.BeachHutsSweden_DE-DE4614841617_1920x1080.jpg";
      name = name';
      colors = {
        #BackgroundLight and BackgroundExtra in dark mode depend on Background
        base00 = "#${value.bgAlt}"; #dark:Background, light:Text Focus
        base01 = "";
        base02 = "";
        base03 = "#${value.accentPrimary}"; #light:Accent Primary
        base04 = "";
        base05 = "#${value.accentSecondary}"; #light:Accent Secondary
        base06 = "";
        base07 = "#${value.btnHoverBg}"; #light:Background Extra
        base08 = "";
        base09 = "";
        base10 = "#${value.textAlt}"; #dark:Accent Primary, light:Background
        base11 = "";
        base12 = "";
        base13 = "#${value.inactiveWorkspace}"; #dark:Accent Secondary
        base14 = "";
        base15 = "#${value.textAlt}"; #dark:Text
      };
    };
  };

  colorFiles =
    lib.foldl' (acc: item: {home.file = acc.home.file // item.home.file;}) {home.file = {};} (lib.attrValues (lib.mapAttrs (name: value: mkColorFile name value) unpacked));
in {
  config = lib.mkIf config.hm.firefox.hot-reload.enable (lib.mkMerge [
    {
      home.activation.pywalfox = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.pywalfox-native}/bin/pywalfox install
      '';

      home.packages = with pkgs; [
        pywalfox-native
        python3
      ];
      hm.hot-reload.scriptParts = {
        "6" = ''
          cp -rf "${directory}/pywalfox_colorschemes/$1.json" "${directory}/colors.json"
        '';
        "10" = ''
          pywalfox update
          pywalfox $mode
        '';
      };

      programs.firefox = {
        profiles.default.extensions = [pkgs.nur.repos.rycee.firefox-addons.pywalfox];
      };
    }
    colorFiles
  ]);
}
