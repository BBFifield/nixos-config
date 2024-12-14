{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}: let
  base16-schemes = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "b3273211d5d1510aee669083fc5a1e0e4b5e310c";
    sha256 = "sha256-UCRGabAyj8+RFkKdSZBR8BPE6yLM3rPpdxXHmwd9rZ0=";
  };
  isYaml = file: lib.hasSuffix ".yaml" file || lib.hasSuffix ".yml" file;
  withoutYamlExtension = file: lib.removeSuffix ".yml" (lib.removeSuffix ".yaml" file);
  dirEntries = lib.attrNames (builtins.readDir "${base16-schemes}/base16");
  themeFiles = lib.filter isYaml dirEntries;
  mkThemePackage = themeFile: let
    name = lib.removeSuffix ".yaml" (lib.removeSuffix ".yml" themeFile);
  in
    lib.nameValuePair name (stdenvNoCC.mkDerivation {
      inherit name;
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out
        runHook preInstall
        cp --reflink=auto ${base16-schemes}/base16/${themeFile} $out
        runHook postInstall
      '';
    });
  themeDerivations = map mkThemePackage themeFiles;
in
  lib.listToAttrs themeDerivations
