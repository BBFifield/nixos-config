{
  config,
  lib,
  pkgs,
  ...
}: let
  mkWriteable = import ../../../../utils/mkWriteable.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    # spaghettikart
    (callPackage ./pkgs/spaghettikart.nix {})
  ];
  home.activation = {
    mkSKConfigWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${mkWriteable} "${./config}" "${config.home.homeDirectory}/.local/share/spaghettikart"
    '';
  };
}
