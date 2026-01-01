{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      dolphin-emu
    ];

    home.file = {
      ".config/dolphin-emu/" = {
        source = ./config;
        recursive = true;
      };
      ".local/share/dolphin-emu" = {
        source = ./local;
        recursive = true;
        force = true;
      };
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
