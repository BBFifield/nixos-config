{
  config,
  overlays,
  lib,
  pkgs,
  inputs,
  ...
}: let
  commonOpts = {
    theme = {
      fonts.defaultMonospace = "JetBrainsMono Nerd Font";
      cursorTheme.name = "BreezeX-Dark";
      cursorTheme.size = 24;
    };
    hidpi.enable = true;
  };
  desktops = {
    hyprland = {
      hyprland.enable = true;
      hyprland.shell = "tintednix";
      displayManager = "greetd";
      nautilus.enable = true;
    };
    plasma = {
      plasma.enable = true;
      displayManager = "sddm";
    };
    gnome = {
      gnome.enable = true;
      displayManager = "gdm";
      nautilus.enable = true;
    };
  };

  defaultDesktop = "hyprland";

  specialisations = false;

  ######################################################################

  specialisationSet = builtins.removeAttrs desktops [defaultDesktop];
  defaultConfiguration = {
    desktop = (lib.filterAttrs (name: value: name == defaultDesktop) desktops).${defaultDesktop};
  };

  featuresDir = ../../features/nixos;
  features = [
    "base"
    "cups"
    "nvidia"
    "home-manager"
    "desktop"
  ];
in {
  imports = lib.mkImports features featuresDir;

  config = lib.mkMerge [
    (lib.mkIf (specialisations == false) {
      nixos = defaultConfiguration;
    })
    (lib.mkIf (specialisations == true) (
      lib.mkIf (config.specialisation != {}) {
        nixos = defaultConfiguration;

        specialisation =
          builtins.mapAttrs (
            name: value: {
              name = name;
              value = {
                inheritParentConfig = true;
                configuration =
                  {
                    system.nixos.tags = [name];
                  }
                  // {
                    nixos = {
                      desktop = value;
                    };
                  };
              };
            }
          )
          specialisationSet;
      }
    ))
    {
      nixos.desktop = commonOpts;

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.binfmt.emulatedSystems = ["armv7l-linux"];

      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      environment.systemPackages = with pkgs; [
        cachix
        #ssh-to-age
        #age
        #sops
        htop
        nix-output-monitor
        openrgb-with-all-plugins
      ];

      programs.bash.shellAliases = {
        sudo = "sudo ";
        nixos-rebuild = "nixos-rebuild ";
        switch = "switch --log-format internal-json -v |& nom --json";
      };

      services.hardware.openrgb.enable = true;

      nixpkgs = {
        overlays =
          overlays.defaults
          ++ (with overlays; [
            nonFlakeSrcs
            vivaldiFixed
            firefox-native-base16
            customPkgs
            asztalOverlay
          ]);
        config.allowUnfree = true;
      };

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Enable sound with pipewire.
      hardware.pulseaudio.enable = lib.mkForce false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
        wireplumber = {
          enable = true;
        };
      };

      #virtualisation.virtualbox.host.enable = true;
      #users.extraGroups.vboxusers.members = [ "brandon" ];

      hardware = {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
      };
    }
  ];
}
