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
      steam-rom-manager
    ];

    home.activation = lib.mkIf (config.hm.steam.userID != "") {
      mkSrmShortcutsWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${mkWriteable} "${./userConfigurations.json}" "${config.home.homeDirectory}/.config/steam-rom-manager/userConfigurations.json"
        ${mkWriteable} "${./userExceptions.json}" "${config.home.homeDirectory}/.config/steam-rom-manager/userExceptions.json"
        ${mkWriteable} "${./userSettings.json}" "${config.home.homeDirectory}/.config/steam-rom-manager/userSettings.json"
      '';
    };
  };
}
