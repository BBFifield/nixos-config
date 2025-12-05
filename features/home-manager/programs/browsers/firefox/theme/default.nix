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
        ".mozilla/firefox/default/chrome/customUserChrome.css".source = ./style/userChrome.css;
        ".mozilla/firefox/default/chrome/parts/commonDialog.css".source = ./style/parts/commonDialog.css;
      };

      programs.firefox.profiles.default = {
        id = 0; # 0 is the default profile; see also option "isDefault"
        inherit settings;
      };
    }
  ];
}
