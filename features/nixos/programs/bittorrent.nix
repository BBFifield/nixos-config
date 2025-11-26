{
  config,
  pkgs,
  ...
}: {
  # services.transmission.enable = true;
  environment.systemPackages = with pkgs; [stig];
}
