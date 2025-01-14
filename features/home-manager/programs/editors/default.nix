{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./kate
    ./neovim
    ./vscodium
  ];
  config = {
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
      nodejs_23
    ];
  };
}
