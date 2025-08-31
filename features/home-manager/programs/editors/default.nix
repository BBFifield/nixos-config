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
    xdg.configFile."stylelint.config.js".text = import ./stylelint.config.nix pkgs.nodePackagesCustom.stylelint-config-clean-order pkgs.nodePackagesCustom.stylelint-high-performance-animation;

    home.packages = with pkgs; [
      alejandra
      nil
      lua-language-server
      stylua
      stylelint
      nodePackagesCustom.stylelint-config-clean-order
      nodePackagesCustom.stylelint-high-performance-animation
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
