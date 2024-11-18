{
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    (lib.concatMap import [./programs])
    ++ [./lookAndFeel]
    ++ [./lookAndFeel/snow-globe];

  options.hm = {
    hot-reload = lib.mkOption {
      type = (import ./submodules {inherit lib;}).hot-reload;
    };
    projectPath = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Where the project is stored before evaluation. This option is used to update configuration files symlinked from the project to
        wherever they are typically put without having to rebuild the entire configuration.
      '';
    };
    hidpi.enable = lib.mkEnableOption "Enable hidpi (which just makes the scale 2x in relevant parts of the configuration).";
  };

  config = lib.mkIf config.hm.hot-reload.enable {
    home.packages = [
      (pkgs.writeTextFile {
        name = "switch-colorscheme";
        text = config.hm.theme.hot-reload.scriptParts;
        executable = true;
        destination = "/bin/switch-colorscheme";
      })
    ];
  };
}
