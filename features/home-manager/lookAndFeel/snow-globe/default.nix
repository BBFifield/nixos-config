{
  config,
  pkgs,
  lib,
  ...
}: let
  enabledSchemes = config.snow-globe.enabledSchemes;

  base16schemes = let
    yamlFiles = lib.map (packageName: let
      schemeName = lib.getName packageName;
      path = "${packageName}/${schemeName}.yaml";
    in
      path)
    enabledSchemes;
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

  sassColors = let
    schemeList =
      lib.map (theme: {
        name = theme.name;
        value = let
          theme' = theme.value.withHashtag;
        in ''
          $base00: ${theme'.base00};
          $base00: ${theme'.base00};
          $base01: ${theme'.base01};
          $base02: ${theme'.base02};
          $base03: ${theme'.base03};
          $base04: ${theme'.base04};
          $base05: ${theme'.base05};
          $base06: ${theme'.base06};
          $base07: ${theme'.base07};
          $base08: ${theme'.base08};
          $base09: ${theme'.base09};
          $base0A: ${theme'.base0A};
          $base0B: ${theme'.base0B};
          $base0C: ${theme'.base0C};
          $base0D: ${theme'.base0D};
          $base0E: ${theme'.base0E};
          $base0F: ${theme'.base0F};
        '';
      })
      base16schemes;
  in
    lib.listToAttrs schemeList;
in {
  imports = [./apps/ironbar ./apps/walker ./apps/hyprland ./apps/alacritty ./apps/neovim];

  options.snow-globe = {
    enable = lib.mkEnableOption "Enable Stylix.";
    enabledSchemes = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.base16; [catppuccin-frappe];
    };
    defaultScheme = lib.mkOption {
      type = lib.types.package;
      default = pkgs.base16.catppuccin-frappe;
    };
    base16schemes = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = {};
    };
    commonColors = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
    sassColors = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config =
    lib.mkIf config.snow-globe.enable
    {
      snow-globe.base16schemes = base16schemes;
      snow-globe.commonColors = commonColors;

      snow-globe.sassColors = sassColors;
    };
}
