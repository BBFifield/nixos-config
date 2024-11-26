{
  config,
  lib,
  ...
}: let
  cfg = config.hm.terminal;
in {
  options.hm.terminal = {
    shell = lib.mkOption {
      type = lib.types.enum ["bash"];
      default = "bash";
    };
  };
  config = lib.mkIf (cfg.shell == "bash") (
    lib.mkMerge [
      {
        programs.bash.enable = true;
        programs.zoxide = {
          enable = true;
          enableBashIntegration = true;
        };
      }
    ]
  );
}
