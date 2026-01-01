{pkgs, ...}: {
  home.packages = with pkgs; [
    rpcs3
  ];

  home.file = {
    ".config/rpcs3/" = {
      source = ./config;
      recursive = true;
    };
  };
}
