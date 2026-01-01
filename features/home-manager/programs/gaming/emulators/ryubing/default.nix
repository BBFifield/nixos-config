{
  config,
  pkgs,
  lib,
  ...
}: let
  mkWriteable = import ../../../../utils/mkWriteable.nix {inherit pkgs;};
in {
  config = {
    home.packages = with pkgs; [
      ryubing
    ];
    home.activation = {
      mkRyubingConfigWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${mkWriteable} "${./config/Config.json}" "${config.home.homeDirectory}/.config/Ryujinx/Config.json"
        ${mkWriteable} "${./config/sdcard}" "${config.home.homeDirectory}/.config/Ryujinx/sdcard"
      '';
    };
  };
}
