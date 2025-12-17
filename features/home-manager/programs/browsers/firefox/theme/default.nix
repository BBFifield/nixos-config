{
  config,
  pkgs,
  lib,
  ...
}: let
  wavefoxSrc = pkgs.fetchFromGitHub {
    owner = "QNetITQ";
    repo = "WaveFox";
    rev = "main"; # or commit
    sha256 = "sha256-QfV9Wc8xfbgbDtG9fiKoA1E+GG6J4XFneNLuKhO05Vw=";
  };

  patchedPackage = pkgs.stdenv.mkDerivation {
    name = "wavefox-chrome-patched";
    src = wavefoxSrc;
    patches = [./wavefox-import-inject.patch];
    buildPhase = ''
      mkdir -p $out
      cp -r chrome $out/
    '';
  };

  settings = import ./wavefoxSettings.nix {};
in {
  options.hm.browsers.firefox = {
    enableCustomUserChrome = lib.mkEnableOption "Choose whether to inject custom stylesheet into WaveFox's userChrome.css.";
  };
  config = lib.mkMerge [
    {
      hm.browsers.firefox.enableCustomUserChrome = true;
      home.file.".mozilla/firefox/default/chrome" = let
        wavefoxPackage =
          if config.hm.browsers.firefox.enableCustomUserChrome
          then patchedPackage
          else pkgs.wavefox;
      in {
        source = "${wavefoxPackage}/chrome";
        recursive = true;
        force = true;
      };
    }
    {
      home.file = lib.mkIf (config.hm.browsers.firefox.enableCustomUserChrome) {
        ".mozilla/firefox/default/chrome/base16/customUserChrome.css".source = ./style/customUserChrome.css;
        ".mozilla/firefox/default/chrome/base16/pages" = {
          source = ./style/pages;
          recursive = true;
        };
        ".mozilla/firefox/default/chrome/base16/parts" = {
          source = ./style/parts;
          recursive = true;
        };
        ".mozilla/firefox/default/chrome/base16/icons" = {
          source = ./style/icons;
          recursive = true;
        };
      };

      programs.firefox.profiles.default = {
        id = 0; # 0 is the default profile; see also option "isDefault"
        settings =
          settings
          //
          #This preference is required to recolor the icons, otherwise you will get black icons everywhere.
          {"svg.context-properties.content.enabled" = true;};
      };
    }
  ];
}
