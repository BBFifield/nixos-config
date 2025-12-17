{
  config,
  pkgs,
  lib,
  ...
}: let
  mkWriteable = import ../../utils/mkWriteable.nix {inherit pkgs;};
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
    home.packages = with pkgs; [
      dolphin-emu
      # sm64ex
      # sm64baserom
    ];
    xdg.dataFile."bin/exit_gamescope_session.sh".source = ./exit_gamescope_session.sh;

    home.activation = lib.mkIf (config.hm.steam.userID != "") {
      mkSteamShortcutsWriteable = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${mkWriteable} "${config.hm.steam.shortcutsFile}" "${config.home.homeDirectory}/.local/share/Steam/userdata/${config.hm.steam.userID}/config/shortcuts.vdf"
      '';
    };
    # Need QT_SCALE_FACTOR to only apply to specific apps
    xdg.desktopEntries."dolphin-emu" = {
      name = "dolphin-emu";
      icon = "dolphin-emu";
      exec = "env QT_SCALE_FACTOR=2 dolphin-emu";
      terminal = false;
      type = "Application";
      genericName = "Wii/GameCube Emulator";
      categories = ["Game" "Emulator"];
      comment = "A Wii/GameCube Emulator";
    };
  };
}
