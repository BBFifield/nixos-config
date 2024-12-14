{lib}: {
  live = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Allow switching configurations on the fly. This only applies to the tintednix hyprland shell for now.";
      hooks = lib.mkOption {
        type = lib.types.submodule {
          options = {
            hotReload = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = ''A command to reload a program's state after configuration changes'';
            };
            onActivation = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = ''Specified commands to run upon home-manager activation. Usually used when you need a way to reset a program's state after it had been changed between rebuild iterations.'';
            };
          };
        };
        default = {
          hotReload = "";
          onActivation = "";
        };
      };
    };
  };
}
