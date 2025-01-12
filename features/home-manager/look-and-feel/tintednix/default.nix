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
          # templateRepo = lib.mkOption {
          #   type = lib.types.attrs;
          #   default = {};
          # };
          templateSrc = lib.mkOption {
            type = with types; either mkGithubType path;
          };
          templateName = lib.mkOption {
            type = lib.types.str;
            default = "default";
          };
          path = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          schemeFilename = lib.mkOption {
            type = lib.types.str;
            default = "colors";
          };
          schemeExtension = lib.mkOption {
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
      default = base16schemes;
    };
    commonColors = lib.mkOption {
      type = lib.types.attrs;
      default = commonColors;
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
            arg1=$1
            directory=${config.home.homeDirectory}/.config
            arg2="$2"

            tintednix=/etc/profiles/per-user/brandon/bin/tintednix

            if [[ $arg1 == "get" ]]; then
              grep "$arg2=" "$directory/tintednix/settings.txt" | cut -d '=' -f 2
            elif [[ $arg1 == "update" ]]; then
              # Clear the contents of the target file
              sed -i '1,$d' "$directory/tintednix/settings.txt"
              source_file_content=$(cat "$directory/tintednix/color-schemes/$arg2.txt")
              gawk -i inplace -v src="$source_file_content" '{ print } ENDFILE { print src }' "$directory/tintednix/settings.txt" || echo "Failed to update settings"
          '')
        (lib.mkOrder 2000
          ''
            fi
          '')
      ];
      targetHooks' = lib.mkMerge [targetHooks scriptParts];
    in
      lib.mkMerge [
        {
          home = targetFiles;
          xdg.configFile."tintednix/settings.txt".text = let
            bases = commonColors.${config.tintednix.defaultScheme}.colors;
          in ''
            color_scheme=${config.tintednix.defaultScheme}
            base00=#${bases.base00}
            base01=#${bases.base01}
            base02=#${bases.base02}
            base03=#${bases.base03}
            base04=#${bases.base04}
            base05=#${bases.base05}
            base06=#${bases.base06}
            base07=#${bases.base07}
            base08=#${bases.base08}
            base09=#${bases.base09}
            base0A=#${bases.base0A}
            base0B=#${bases.base0B}
            base0C=#${bases.base0C}
            base0D=#${bases.base0D}
            base0E=#${bases.base0E}
            base0F=#${bases.base0F}
          '';
        }
        {
          home = let
            schemeFilesList =
              lib.map (schemeAttrs: {
                file.".config/tintednix/color-schemes/${schemeAttrs.name}.txt".text = ''
                  color_scheme=${schemeAttrs.name}
                  base00=#${schemeAttrs.value.base00}
                  base01=#${schemeAttrs.value.base01}
                  base02=#${schemeAttrs.value.base02}
                  base03=#${schemeAttrs.value.base03}
                  base04=#${schemeAttrs.value.base04}
                  base05=#${schemeAttrs.value.base05}
                  base06=#${schemeAttrs.value.base06}
                  base07=#${schemeAttrs.value.base07}
                  base08=#${schemeAttrs.value.base08}
                  base09=#${schemeAttrs.value.base09}
                  base0A=#${schemeAttrs.value.base0A}
                  base0B=#${schemeAttrs.value.base0B}
                  base0C=#${schemeAttrs.value.base0C}
                  base0D=#${schemeAttrs.value.base0D}
                  base0E=#${schemeAttrs.value.base0E}
                  base0F=#${schemeAttrs.value.base0F}
                '';
              })
              base16schemes;
          in
            lib.mkMerge [(lib.foldl' (acc: item: {file = acc.file // item.file;}) {file = {};} schemeFilesList)];
        }
        {
          tintednix.live.hooks.hotReload = targetHooks';
          home.packages = [
            (pkgs.writeShellApplication {
              name = "tintednix";
              runtimeInputs = with pkgs; [bash coreutils gnugrep gnused gawk];
              text = config.tintednix.live.hooks.hotReload; # this bad, i know
            })
          ];
        }
      ]
  );
}
