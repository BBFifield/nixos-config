{
  config,
  lib,
  pkgs,
  ...
}: let
  mkWriteable = import ../../../../utils/mkWriteable.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    shipwright
  ];
  home.activation = {
    mkSOHConfigWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${mkWriteable} "${./config}" "${config.home.homeDirectory}/.local/share/soh"
    '';
  };
}
