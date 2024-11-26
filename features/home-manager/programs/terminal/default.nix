{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.terminal;
in {
  imports = [
    ./alacritty
    ./starship
    ./konsole
    ./shell
  ];

  options.hm.terminal = {
    default = mkOption {
      type = with types; nullOr enum ["alacritty" "konsole"];
      default = "alacritty";
    };
  };

  config = mkMerge [
    {
      hm.starship = {
        enable = true;
      };
    }
  ];
}
