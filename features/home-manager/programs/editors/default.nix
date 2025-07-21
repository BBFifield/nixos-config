{
  config,
  lib,
  pkgs,
  ...
}: let
  # Mostly to show how an npm package and dependencies can be built
  stylelint-config-standard = pkgs.buildNpmPackage rec {
    pname = "stylelint-config-standard";
    version = "38.0.0"; # match the npm release you want

    src = pkgs.fetchFromGitHub {
      owner = "stylelint";
      repo = "stylelint-config-standard";
      tag = version;
      sha256 = "1gsmqk91a8n063bz9vb9kj6djc0j92pgg7c8ikqbbf8g2xjspyja";
    };
    # use the package.json shipped in the repo
    packageJSON = src + "/package.json";
    npmDepsHash = "sha256-U1MUaDsZmkNiU7al2OTlDYjVkqzDslXQUZm7bsqqMBA=";

    dontNpmBuild = true;
  };
in {
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
    xdg.configFile."stylelint.config.js".source = ./stylelint.config.js;

    home.packages = with pkgs; [
      alejandra
      nil
      lua-language-server
      stylua
      stylelint
      stylelint-config-standard
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
