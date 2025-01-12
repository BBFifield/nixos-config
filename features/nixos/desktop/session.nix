{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop;

  plasmaSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable the plasma desktop environment.";
    };
  };
  gnomeSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable the gnome desktop environment.";
    };
  };
  hyprlandSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable Hyprland Window Manager.";
      shell = mkOption {
        type = types.enum ["asztal" "tintednix" "hyprpanel"];
        default = "tintednix";
        description = "Choose your preferred Hyprland shell";
        example = "asztal";
      };
    };
  };
in {
  options.nixos.desktop = {
    plasma = mkOption {
      type = plasmaSubmodule;
      default = {
        enable = false;
      };
    };
    gnome = mkOption {
      type = gnomeSubmodule;
      default = {
        enable = false;
      };
    };
    hyprland = mkOption {
      type = hyprlandSubmodule;
      default = {
        enable = false;
        shell = "tintednix";
      };
    };
  };

  config =
    {services.xserver.enable = true;}
    // mkMerge [
      (mkIf (cfg.plasma.enable) {
        # Enable the KDE Plasma 6 Desktop Environment.
        services.desktopManager.plasma6.enable = true;

        environment.systemPackages = with pkgs.kdePackages; [
          sddm-kcm
          partitionmanager
          kpmcore
          kde-cli-tools
          kdbusaddons
          isoimagewriter
        ];
      })

      (mkIf (cfg.gnome.enable) {
        # Enable the Gnome desktop environment
        services.xserver.desktopManager.gnome.enable = true;

        environment.systemPackages = with pkgs; [
          gnome-tweaks
          dconf-editor
          dconf2nix
        ];
      })

      (mkIf (cfg.hyprland.enable) (
        mkMerge [
          {
            programs.uwsm = {
              enable = true;
              waylandCompositors = {
                hyprland = {
                  prettyName = "Hyprland";
                  comment = "Hyprland compositor managed by UWSM";
                  binPath = "/run/current-system/sw/bin/Hyprland";
                };
              };
            };
            # Enable the hyprland "desktop environment"
            programs.hyprland = {
              enable = true;
              # withUWSM = true;
              #systemd.setPath.enable = true;
            };
            environment.systemPackages = with pkgs; [
              bun
              gnome-tweaks
              kdePackages.qtwayland #QT apps will not open under wayland mode otherwise
              kdePackages.qt6ct
              gnome-control-center
            ];

            security = {
              polkit.enable = true;
              # pam.services.ags = {};
            };

            services = {
              gvfs.enable = true;
              devmon.enable = true;
              udisks2.enable = true;
              upower.enable = true;
              power-profiles-daemon.enable = true;
              accounts-daemon.enable = true;
              gnome = {
                glib-networking.enable = true;
                gnome-keyring.enable = true;
                localsearch.enable = true;
                tinysparql.enable = true;
              };
            };
          }
          # Hyprlock doesn't work without this
          (mkIf (cfg.hyprland.shell == "tintednix") {
            security.pam.services.hyprlock = {};
          })
        ]
      ))
    ];
}
