{
  config,
  lib,
  pkgs,
  ...
}: let
  profilesPath = ".mozilla/firefox";
  directory = "${config.home.homeDirectory}/.cache/wal";

  jsonFormat = pkgs.formats.json {};

  schemeAttrs = config.snow-globe.commonColors;

  schemeNames = lib.attrNames schemeAttrs;

  defaultTheme = config.hm.theme.colorscheme.name;
  defaultVariant = config.hm.theme.colorscheme.variant;

  unpacked = lib.listToAttrs (lib.map (schemeName: {
      name = schemeName;
      value = schemeAttrs.${schemeName}.colors;
    })
    schemeNames);

  mkColorFile = name': value: path: {
    file.".cache/wal/${path}${name'}.json" = {
      source = jsonFormat.generate "${name'}" {
        wallpaper = "/home/brandon/Pictures/wallpapers/Bing/OHR.BeachHutsSweden_DE-DE4614841617_1920x1080.jpg";
        name = name';
        colors = {
          base00 = "#${value.base00}";
          base01 = "#${value.base01}";
          base02 = "#${value.base02}";
          base03 = "#${value.base03}";
          base04 = "#${value.base04}";
          base05 = "#${value.base05}";
          base06 = "#${value.base06}";
          base07 = "#${value.base07}";
          base08 = "#${value.base08}";
          base09 = "#${value.base09}";
          base0A = "#${value.base05}";
          base0B = "#${value.base0B}";
          base0C = "#${value.base0C}";
          base0D = "#${value.base0D}";
          base0E = "#${value.base0E}";
          base0F = "#${value.base05}";
        };
      };
    };
  };

  colorFiles = {
    home = lib.mkMerge [
      (lib.foldl' (acc: item: {file = acc.file // item.file;}) {file = {};}
        (
          lib.attrValues (lib.mapAttrs (name: value: mkColorFile name value "pywalfox_colorschemes/") unpacked)
        ))
    ];
  };
in {
  options.hm.firefox.pywalfox = {
    enable = lib.mkEnableOption "Enable pywalfox, a dynamic firefox colorscheme client.";
  };
  config = lib.mkIf (config.hm.firefox.pywalfox.enable) (
    lib.mkMerge [
      #This file is created regardless
      {home = mkColorFile "colors" schemeAttrs."${defaultTheme}-${defaultVariant}".colors "";}
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
          ${pkgs.pywalfox-native}/bin/pywalfox ${schemeAttrs."${defaultTheme}-${defaultVariant}".variant}
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
