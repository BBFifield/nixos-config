{
  config,
  pkgs,
  lib,
}: rec {
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
      (lib.foldl' (acc: item: {file = acc.file // item.file;}) {file = {};}
        (lib.map (name: (linkStyleFile appName name styleFiles.${name})) names))
    ];
  };

  /*
      applyToList = function:
  lib.map (scheme: function scheme target.value.templateRepo target.value.templateName) (
        if config.tintednix.enabledSchemes == "all"
        then lib.filter (packageAttr: packageAttr.name != "override" && packageAttr.name != "overrideDerivation") (lib.attrsToList pkgs.base16)
        else config.tintednix.enabledSchemes
      );
  */

  mkConfigFromTemplate = scheme: templateRepo: templateName: let
    name =
      if lib.isDerivation scheme
      then lib.getName scheme.name
      else scheme.name;

    schemeAttrs =
      if lib.isDerivation scheme
      then config.lib.base16.mkSchemeAttrs "${scheme}/${name}.yaml"
      else config.lib.base16.mkSchemeAttrs "${scheme.value}/${name}.yaml";
  in {
    schemeName = name;
    generatedConfig =
      if !(lib.isPath templateRepo)
      then
        (schemeAttrs.__functor schemeAttrs) {
          templateRepo = builtins.fetchGit templateRepo;
          target = templateName;
        }
      else null;
  };

  mkTargetFiles = target: let
    configs = lib.map (scheme: mkConfigFromTemplate scheme target.value.templateRepo target.value.templateName) (
      if config.tintednix.enabledSchemes == "all"
      then lib.filter (packageAttr: packageAttr.name != "override" && packageAttr.name != "overrideDerivation") (lib.attrsToList pkgs.base16)
      else config.tintednix.enabledSchemes
    );
    themeFilesList =
      if config.tintednix.targets.${target.name}.live.enable
      then lib.map (config: {file."${target.value.path}/themes/${config.schemeName}.${target.value.themeExtension}".source = config.generatedConfig;}) configs
      else [];

    defaultThemeFile = [
      {
        file."${target.value.path}/${target.value.themeFilename}.${target.value.themeExtension}" = let
          defaultScheme = config.tintednix.defaultScheme;
          defaultConfig = mkConfigFromTemplate defaultScheme target.value.templateRepo target.value.templateName;
        in {
          source = defaultConfig.generatedConfig;
        };
      }
    ];
  in
    lib.mkMerge [(lib.foldl' (acc: item: {file = acc.file // item.file;}) {file = {};} (themeFilesList ++ defaultThemeFile))];

  mkTargetHooks = targets:
    lib.map
    (target:
      if target.live.enable
      then
        lib.mkMerge [
          (lib.mkBefore ''
            cp -rf ${config.home.homeDirectory}/${target.path}/themes/$1.${target.themeExtension} ${config.home.homeDirectory}/${target.path}/${target.themeFilename}.${target.themeExtension}
          '')
          (
            lib.mkAfter ''${target.live.hooks}''
          )
        ]
      else '''') (lib.attrValues targets);
}
