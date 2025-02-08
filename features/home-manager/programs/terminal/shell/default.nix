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
        programs.bash = {
          enable = true;
          initExtra = lib.mkIf (config.hm.starship.enable) ''
            show_newline() {
              if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
                NEW_LINE_BEFORE_PROMPT=1
              elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
                echo ""
              fi
            }
            if [[ $TERM != "dumb" ]]; then
              PROMPT_COMMAND="show_newline"
              eval "$(${config.home.profileDirectory}/bin/starship init bash --print-full-init)"
            fi
          '';
        };
        programs.zoxide = {
          enable = true;
          enableBashIntegration = true;
        };
      }
    ]
  );
}
