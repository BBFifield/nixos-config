{
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    (lib.concatMap import [./programs])
    ++ [./look-and-feel]
    ++ [./look-and-feel/tintednix];

  options.hm = {
    live = lib.mkOption {
      type = (import ./submodules {inherit lib;}).live;
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

  /*
    config = lib.mkIf config.hm.live.enable {
    home.packages = [
      (pkgs.writeTextFile {
        name = "tintednix";
        text = config.hm.theme.live.hooks;
        executable = true;
        destination = "/bin/tintednix";
      })
    ];
  };
  */
}
