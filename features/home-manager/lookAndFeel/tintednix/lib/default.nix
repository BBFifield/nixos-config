{
  config,
  pkgs,
  lib,
}: let
  tomlTemplate = ''      
    # Base16 {{scheme-name}}
    # Scheme by {{scheme-author}}

    base00 = "#{{base00-hex}}"
    base01 = "#{{base01-hex}}"
    base02 = "#{{base02-hex}}"
    base03 = "#{{base03-hex}}"
    base04 = "#{{base04-hex}}"
    base05 = "#{{base05-hex}}"
    base06 = "#{{base06-hex}}"
    base07 = "#{{base07-hex}}"
    base08 = "#{{base08-hex}}"
    base09 = "#{{base09-hex}}"
    base0A = "#{{base0A-hex}}"
    base0B = "#{{base0B-hex}}"
    base0C = "#{{base0C-hex}}"
    base0D = "#{{base0D-hex}}"
    base0E = "#{{base0E-hex}}"
    base0F = "#{{base0F-hex}}"'';
in rec {
  /*
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
  */

  mkConfigFromTemplate = scheme: templateRepo: templateName: let
    schemeAttrs = scheme.value;
  in {
    schemeName = scheme.name;
    generatedConfig =
      if !(lib.isPath templateRepo)
      then
        (schemeAttrs.__functor schemeAttrs) {
          templateRepo = builtins.fetchGit templateRepo;
          target = templateName;
        }
      else null;
  };

  mkConfigFromTemplateFirefox = scheme: template: let
    schemeAttrs = scheme.value;
  in {
    schemeName = scheme.name;
    generatedConfig = (schemeAttrs.__functor schemeAttrs) {
      template = template;
    };
  };

  mkTargetFiles = target: let
    configs =
      if target.value.templateName == "toml"
      then lib.map (scheme: mkConfigFromTemplateFirefox scheme tomlTemplate) (config.tintednix.base16schemes)
      else lib.map (scheme: mkConfigFromTemplate scheme target.value.templateRepo target.value.templateName) (config.tintednix.base16schemes);
    themeFilesList =
      if config.tintednix.targets.${target.name}.live.enable
      then lib.map (config: {file."${target.value.path}/themes/${config.schemeName}.${target.value.themeExtension}".source = config.generatedConfig;}) configs
      else [];

    defaultThemeFile = [
      {
        file."${target.value.path}/${target.value.themeFilename}.${target.value.themeExtension}" = let
          defaultConfig = let
            defaultScheme = lib.head (lib.filter (scheme: (scheme.name == config.tintednix.defaultScheme)) config.tintednix.base16schemes);
          in
            if target.value.templateName == "toml"
            then mkConfigFromTemplateFirefox defaultScheme tomlTemplate
            else mkConfigFromTemplate defaultScheme target.value.templateRepo target.value.templateName;
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
