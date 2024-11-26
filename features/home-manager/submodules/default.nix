{lib}: {
  live = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Allow switching configurations on the fly. This only applies to the tintednix hyprland shell for now.";
      hooks = lib.mkOption {
        type = lib.types.lines;
        default = '''';
      };
    };
  };
}
