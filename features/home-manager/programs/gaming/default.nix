{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    dolphin-emu
    steam
    # sm64ex
    # sm64baserom
  ];
}
