{
  config,
  lib,
  pkgs,
  ...
}: let
  mkWriteable = import ../../../../utils/mkWriteable.nix {inherit pkgs;};
in {
  programs.sm64ex = {
    enable = true;
    settings = {
      fullscreen = true;
      key_a = ["0026" "1001" "1103"];
      key_b = ["0033 1003 1101"];
      skip_intro = 1;
    };
    package = pkgs.callPackage ./pkgs/render96.nix {sm64baserom = ./baserom.us.z64;};
  };
  home.activation = {
    mkSM64ConfigWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${mkWriteable} "${./config}" "${config.home.homeDirectory}/.local/share/sm64ex"
    '';
  };
}
