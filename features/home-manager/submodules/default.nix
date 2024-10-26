{lib}: {
  hot-reload = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Allow switching hyprland configurations on the fly. This only applies to the vanilla shell.";
      configList = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = ''
          This is a configuration list to hot-reload.
        '';
      };
      scriptParts = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.str;
        default = {};
      };
    };
  };
}
