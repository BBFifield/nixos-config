{
  config,
  lib,
  pkgs,
  ...
}: let
  configFile = import ./tauonConf.nix {inherit config;};
  mkWriteable = import ../../../utils/mkWriteable.nix {inherit pkgs;};
  generatedConfig = (pkgs.formats.toml {}).generate "tauon.toml" configFile;
in {
  home.packages = with pkgs; [
    tauon
  ];

  home.activation.mkTauonConfWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${mkWriteable} "${generatedConfig}" "${config.home.homeDirectory}/.local/share/TauonMusicBox/tauon.conf"
  '';
}
