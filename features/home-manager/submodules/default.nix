{lib}: {
  hot-reload = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Allow switching hyprland configurations on the fly. This only applies to the snow-globe hyprland shell.";
      scriptParts = lib.mkOption {
        type = lib.types.lines;
        default = '''';
      };
    };
  };
}
