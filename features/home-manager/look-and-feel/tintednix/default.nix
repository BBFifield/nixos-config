{
  config,
  pkgs,
  lib,
  ...
}: let
  enabledSchemes = config.tintednix.enabledSchemes;

  this.lib = import ./lib {inherit config pkgs lib;};

  base16schemes = let
    yamlFiles =
      lib.map (package: let
        schemeName =
          if enabledSchemes == "all"
          then package.name
          else lib.getName package;
        path =
          if enabledSchemes == "all"
          then "${package.value}/${schemeName}.yaml"
          else "${package}/${schemeName}.yaml";
      in
        path)
      (
        if enabledSchemes == "all"
        then lib.filter (packageAttr: packageAttr.name != "override" && packageAttr.name != "overrideDerivation") (lib.attrsToList pkgs.base16)
        else enabledSchemes
      );
    schemeList =
      lib.map (
        filePath: let
          schemeAttrs = config.lib.base16.mkSchemeAttrs filePath;
          slug = schemeAttrs.slug;
        in {
          name = slug;
          value = schemeAttrs;
        }
      )
      yamlFiles;
  in
    schemeList;

  commonColors = let
    schemeList =
      lib.map (schemeAttrs: {
        name = schemeAttrs.name;
        value = {
          variant = schemeAttrs.value.scheme-variant;
          colors = {
            base00 = schemeAttrs.value.base00;
            base01 = schemeAttrs.value.base01;
            base02 = schemeAttrs.value.base02;
            base03 = schemeAttrs.value.base03;
            base04 = schemeAttrs.value.base04;
            base05 = schemeAttrs.value.base05;
            base06 = schemeAttrs.value.base06;
            base07 = schemeAttrs.value.base07;
            base08 = schemeAttrs.value.base08;
            base09 = schemeAttrs.value.base09;
            base0A = schemeAttrs.value.base0A;
            base0B = schemeAttrs.value.base0B;
            base0C = schemeAttrs.value.base0C;
            base0D = schemeAttrs.value.base0D;
            base0E = schemeAttrs.value.base0E;
            base0F = schemeAttrs.value.base0F;
          };
        };
      })
      base16schemes;
  in
    lib.listToAttrs schemeList;

  mkGithubType = lib.mkOptionType {
    name = "mkGitHubType";
    check = src: (builtins.tryEval (builtins.fetchGit src)).success;
  };
in {
  options.tintednix = with lib; {
    enable = lib.mkEnableOption "Enable tintednix.";
    enabledSchemes = lib.mkOption {
      type = with types; either (enum ["all"]) (listOf package);
      default = with pkgs.base16; [catppuccin-frappe];
    };
    targets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Enable configuration of the target.";
          live = lib.mkOption {
            type = (import ../../submodules {inherit lib;}).live;
          };
          templateRepo = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };
          templateName = lib.mkOption {
            type = lib.types.str;
            default = "default";
          };
          path = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          themeFilename = lib.mkOption {
            type = lib.types.str;
            default = "colors";
          };
          themeExtension = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
        };
      });
    };
    live = lib.mkOption {
      type = (import ../../submodules {inherit lib;}).live;
    };
    defaultScheme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-frappe";
    };
    base16schemes = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = {};
    };
    commonColors = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
  config = lib.mkIf (config.tintednix.enable) (
    let
      targetFiles = lib.mkMerge (map this.lib.mkTargetFiles (lib.attrsToList config.tintednix.targets));
      targetHooks = lib.mkMerge (this.lib.mkTargetHooks config.tintednix.targets);

      scriptParts = lib.mkMerge [
        (lib.mkOrder 5
          ''
            #!/usr/bin/env bash
            directory=${config.home.homeDirectory}/.config
            next_colorscheme="$1"
            mode="$2"

            sed -i "/^current_colorscheme=/c\current_colorscheme=$next_colorscheme" "$directory/tintednix/settings.txt"
          '')
      ];
      targetHooks' = lib.mkMerge [targetHooks scriptParts];
    in
      lib.mkMerge [
        {
          home = targetFiles;
          xdg.configFile."tintednix/settings.txt".text = ''current_colorscheme=${config.tintednix.defaultScheme}'';
        }
        {
          tintednix.live.hooks.hotReload = targetHooks';
          home.packages = [
            (pkgs.writeTextFile {
              name = "tintednix";
              text = config.tintednix.live.hooks.hotReload; # this bad, i know
              executable = true;
              destination = "/bin/tintednix";
            })
          ];
        }
        {
          tintednix.base16schemes = base16schemes;
          tintednix.commonColors = commonColors;
        }
      ]
  );
}
