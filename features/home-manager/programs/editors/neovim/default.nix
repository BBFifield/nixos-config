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
    };
    config = mkIf cfg.enable {
      hm.neovimConfig.enable = true;
      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };
    };
  }
