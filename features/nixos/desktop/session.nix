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
        type = types.enum ["tintednix"];
        default = "tintednix";
        description = "Choose your preferred Hyprland shell";
        example = "tintednix";
      };
      displayOutputs = mkOption {
        description = "Monitor options";
        type = with types;
          attrsOf (submodule {
            options = {
              displayProps = mkOption {
                type = with types; nullOr (listOf str);
                default = null;
                example = ["highres@highrr" "0x0" "2"];
              };
              isHDRcapable = mkOption {
                type = bool;
                default = false;
                description = ''Whether the monitor is capable of displaying HDR content.'';
              };
            };
          });
        example = {
          "HDMI-A-1" = {
            displayProps = ["highres@highrr" "0x0" "2"];
            isHDRcapable = true;
          };
        };
      };
      # displayOutputs = mkOption {
      #   type = with types; nullOr (listOf str);
      #   default = null;
      #   example = ["HDMI-A-1, highres@highrr, 0x0, 2"];
      # };
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
        displayOutputs = null;
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
            # Enable the hyprland "desktop environment"
            programs.hyprland = {
              enable = true;
              withUWSM = true;
            };
            environment.systemPackages = with pkgs; [
              bun
              gnome-tweaks
              kdePackages.qtwayland #QT apps will not open under wayland mode otherwise
              kdePackages.qt6ct
              libsForQt5.qt5ct
              catppuccin-qt5ct
              darkly
              darkly-qt5
            ];
            environment.pathsToLink = ["/share/qt5ct/colors" "/share/qt6ct/colors"];

            security.polkit.enable = true;

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
          (mkIf (cfg.hyprland.shell == "tintednix") {
            # Hyprlock doesn't work without this
            security.pam.services.hyprlock = {};
          })
        ]
      ))
    ];
}
