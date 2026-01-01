{pkgs, ...}: {
  imports = [
    ./cemu
    ./dolphin
    ./mupen64plus
    ./rpcs3
    ./ryubing
  ];
}
