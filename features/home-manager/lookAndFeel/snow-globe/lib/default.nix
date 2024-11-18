{
  config,
  pkgs,
  lib,
}: rec {
  #themeNames = lib.attrNames attrset;
  #getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

  /*
    mkCognateList = name: variant: prefix: let
    cognates = attrset.${name}.cognates variant;
  in (lib.map (cognateName: {
    name = "color_${cognateName}";
    value = ''${prefix}${cognates.${cognateName}}'';
  }) (lib.attrNames cognates));
  */

  mkConfigFromTemplate = scheme: template: let
    name = lib.getName scheme;
  in {
    schemeName = name;
    generatedConfig = config.lib.base16.mkSchemeAttrs "${scheme}/${lib.getName scheme}.yaml" (builtins.fetchGit template);
  };

  mkColorsFile = appName: value:
    pkgs.writeTextFile {
      name = "_${appName}_colors.scss";
      text = value;
    };

  mkStyleFile = fileName: value: appName: installPhase: styleFile:
    pkgs.runCommand fileName {nativeBuildInputs = with pkgs; [dart-sass];} ''
      #!/usr/bin/env bash
      mkdir -p $out
      cp -rf "${mkColorsFile appName value}" "$out/_${appName}_colors.scss"
      cp -rf "${styleFile}" "$out/style_${appName}.scss"
      ${installPhase}
    '';

  /*
    unpackColors = lib.concatMap (theme:
    lib.map (variant: {
      name = "${theme}_${variant}";
      value = mkCognateList theme variant;
    }) (getVariantNames theme))
  themeNames;
  */

  mkStyleFiles = appName: sassColorsSet: styleFile:
    lib.mapAttrs (
      name: value:
        mkStyleFile name value appName ''
          sass "$out/style_${appName}.scss" "$out/.config/${appName}/${appName}_colorschemes/${name}.css"
          rm "$out/_${appName}_colors.scss"
        ''
        styleFile
    )
    sassColorsSet;

  linkStyleFile = appName: name: value: {
    configFile."${appName}/${appName}_colorschemes/${name}.css".source = "${value}/.config/${appName}/${appName}_colorschemes/${name}.css";
  };

  linkStyleFiles = appName: styleFiles: let
    names = lib.attrNames styleFiles;
  in {
    xdg = lib.mkMerge [
      (lib.foldl' (acc: item: {configFile = acc.configFile // item.configFile;}) {configFile = {};}
        (lib.map (name: (linkStyleFile appName name styleFiles.${name})) names))
    ];
  };
}
