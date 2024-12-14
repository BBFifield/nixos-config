{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.neovim;
in
  with lib; {
    options.hm.neovim = {
      enable = mkEnableOption "Enable Neovim.";
      pluginManager = mkOption {
        type = with types; nullOr (enum ["lazy" "nix"]);
        default = null;
        description = ''
          Which package manager to use to manage your neovim plugins.
        '';
      };
    };
    config = mkIf cfg.enable {
      hm.neovimConfig.enable = true;
      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };
    };
  }
