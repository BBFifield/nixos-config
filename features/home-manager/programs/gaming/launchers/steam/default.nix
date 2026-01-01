{
  config,
  pkgs,
  lib,
  ...
}: let
  mkWriteable = import ../../../../utils/mkWriteable.nix {inherit pkgs;};
in {
  options.hm.steam = {
    userID = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Your steam user ID. Principally used for placing the shortcuts.vdf in your userData directory.";
      example = "121315676";
    };
    shortcutsFile = lib.mkOption {
      type = lib.types.path;
      default = ./shortcuts.vdf;
      description = ''Your steam shortcuts binary vdf file.'';
    };
  };
  config = {
    xdg.dataFile."bin/exit_gamescope_session.sh".source = ./exit_gamescope_session.sh;

    home.activation = lib.mkIf (config.hm.steam.userID != "") {
      mkSteamShortcutsWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${mkWriteable} "${config.hm.steam.shortcutsFile}" "${config.home.homeDirectory}/.local/share/Steam/userdata/${config.hm.steam.userID}/config/shortcuts.vdf"
      '';
    };
  };
}
