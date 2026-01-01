{config, ...}: {
  xdg.configFile = {
    "dolphin-emu/.stignore".text = ''
      !TimePlayed.ini
      *
    '';
    "rpcs3/.stignore".text = ''
      !persistent-settings.dat
      *
    '';
  };
  # So game states aren't copied from mupen64plus-fz
  xdg.dataFile."RMG/Save/Game/.stignore".text = ''
    /*/
    !*.*
    /
  '';

  services.syncthing = {
    enable = true;
    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    overrideFolders = true; # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "pixel" = {
          name = "Pixel 6a";
          id = "3DYMMW6-EBVAEDZ-AGMC247-TZTOXS4-CH6W2SL-LLKIPB7-2RFPS35-V5IBCA5";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "dolphin-gc-saves" = {
          path = "${config.home.homeDirectory}/.local/share/dolphin-emu/GC";
          devices = ["pixel"];
        };
        # refer to above ignore file definition
        "dolphin-timeplayed" = {
          path = "${config.home.homeDirectory}/.config/dolphin-emu";
          devices = ["pixel"];
        };
        "ryujinx-savedata" = {
          path = "${config.home.homeDirectory}/.config/Ryujinx/bis/user";
          devices = ["pixel"];
        };
        "mupen64plus-saves" = {
          path = "${config.home.homeDirectory}/.local/share/RMG/Save/Game";
          devices = ["pixel"];
        };
        # refer to above ignore file definition
        "rpcs3-timeplayed" = {
          path = "${config.home.homeDirectory}/.config/rpcs3/GuiConfigs";
          devices = ["pixel"];
        };
      };
      options = {
        options.localAnnounceEnabled = -1;
        localAnnounceEnabled = true;
      };
    };
  };
}
