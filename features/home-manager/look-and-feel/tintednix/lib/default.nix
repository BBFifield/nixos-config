{
  config,
  pkgs,
  lib,
}: let
  cfg.home = config.home.homeDirectory;
in rec {
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

  mkTargetFiles = target: let
    configs =
      lib.map (scheme: mkConfigFromTemplate scheme target.value.templateRepo target.value.templateName) (config.tintednix.base16schemes);
    themeFilesList =
      if config.tintednix.targets.${target.name}.live.enable
      then
        lib.map (config: {
          file."${target.value.path}/themes/${config.schemeName}.${target.value.themeExtension}".source = config.generatedConfig;
        })
        configs
      else [];

    defaultThemeFile = [
      {
        file."${target.value.path}/${target.value.themeFilename}.${target.value.themeExtension}" = let
          defaultConfig = let
            defaultScheme = lib.head (lib.filter (scheme: (scheme.name == config.tintednix.defaultScheme)) config.tintednix.base16schemes);
          in
            mkConfigFromTemplate defaultScheme target.value.templateRepo target.value.templateName;
        in {
          source = defaultConfig.generatedConfig;
          onChange = target.value.live.hooks.onActivation;
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
            cp -rf ${cfg.home}/${target.path}/themes/$1.${target.themeExtension} ${cfg.home}/${target.path}/${target.themeFilename}.${target.themeExtension}
          '')
          (
            lib.mkAfter ''${target.live.hooks.hotReload}''
          )
        ]
      else '''') (lib.attrValues targets);
}
