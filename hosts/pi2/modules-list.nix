{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    ./configuration.nix
    "${modulesPath}/installer/sd-card/sd-image-armv7l-multiplatform.nix"
  ];
}
