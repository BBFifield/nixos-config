{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nurpkgs.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gBar = {
      url = "github:scorpion-26/gBar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen.url = "github:InioX/matugen?ref=v2.2.0";

    asztal = {
      url = "github:Aylur/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.ags.follows = "ags";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim-config = {
    #   url = "github:BBFifield/neovim-config";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    neovim-config = {
      url = "git+file:///home/brandon/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";

    base16-nix.url = "github:SenchoPens/base16.nix";

    firefox-native-base16 = {
      url = "github:BBFifield/firefox-native-base16";
      # url = "github:GnRlLeclerc/firefox-native-base16";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-generators,
    ...
  } @ inputs: let
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];

    # Maps a function over the 'systems' attribute set. 'Systems' is provided as the first arg, but it also
    # needs a function as the second arg, which is provided below when forAllSystems is called.
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in rec
  {
    # Merge my custom libraries with the ones defined in nixpkgs.
    lib = nixpkgs.lib.extend (self: super:
      (import ./lib {
        lib = nixpkgs.lib;
      })
      // inputs.home-manager.lib);

    # My custom packages
    # Accessible through 'nix build', 'nix shell', etc
    # Ex: nix shell packages.x86_64-linux.klassy
    packages = forAllSystems (system:
      lib.pathToAttrs "${self}/pkgs" (full_path: _:
        nixpkgs.legacyPackages.${system}.callPackage "${full_path}" {}));

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit self lib inputs;};

    nixosConfigurations = lib.pathToAttrs "${self}/hosts" (full_path: hostname:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs overlays lib hostname;};
        modules = ["${full_path}/modules-list.nix"];
      });

    images = {
      # nix build .#images.pi2
      pi2 = nixosConfigurations.pi2.config.system.build.sdImage;
      # nix build .#images.desktop
      desktop = nixosConfigurations.desktop.config.formats.install-iso;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      # "https://app.cachix.org/cache/bbfifield"
      "https://walker-git.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      #"bbfifield.cachix.org-1:CCnFT1vusYyocjxJNHQKnighiTQSnv/LquQcZ3xrTgg="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
