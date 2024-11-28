{pkgs, ...}: {
  imports = [
    ./kate
    ./neovim
    ./vscodium
  ];

  home.packages = with pkgs; [
    alejandra
    nil
    lua-language-server
    stylua
    prettierd
    dart-sass
    rust-analyzer
    rustfmt
    cargo
    arduino-ide
  ];
}
