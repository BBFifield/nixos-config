{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.sm64ex = {
    enable = true;
    baserom = ./baserom.us.z64;
    extraCompileFlags = [
      "DISCORDRPC=1"
      "TEXTURE_FIX=1"
      "EXTERNAL_DATA=1"
    ];
    settings = {
      fullscreen = true;
      key_a = ["0026" "1001" "1103"];
      key_b = ["0033 1003 1101"];
      skip_intro = 1;
    };
  };
}
