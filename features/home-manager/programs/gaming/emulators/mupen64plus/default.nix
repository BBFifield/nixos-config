{
  config,
  lib,
  pkgs,
  ...
}: let
  mkWriteable = import ../../../../utils/mkWriteable.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    rmg-wayland
  ];
  home.activation = {
    mkMupenConfigWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${mkWriteable} "${./config}" "${config.home.homeDirectory}/.config/RMG"
    '';
  };
}
