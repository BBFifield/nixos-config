{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./kate
    ./neovim
    ./vscodium
  ];

  options.hm.editors = {
    defaultEditor = lib.mkOption {
      type = lib.types.enum ["kate" "nvim" "codium"];
      default = "nvim";
    };
  };

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
      nodejs_24
      npm-check-updates
      typescript
      typescript-language-server
      nodePackages.vscode-json-languageserver
      sops
      age
    ];
  };
}
