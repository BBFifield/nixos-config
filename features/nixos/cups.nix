{...}: {
  # Enable CUPS to print documents.
  services = {
    printing.enable = true;
    # # https://www.reddit.com/r/NixOS/comments/k8yo9e/comment/k13rjna/
    # # Avahi is used by the cups daemon to discover ipp printers over a network, no driver for the
    # # specific printer is needed
    avahi.enable = true;
    avahi.nssmdns4 = true;
    avahi.openFirewall = true;
  };
}
