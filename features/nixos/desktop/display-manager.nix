# Credit goes to github:Cu3P042 for the code snippet which changes the users' avatar in sddm.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nixos.desktop;
in {
  options.nixos.desktop = {
    displayManager = mkOption {
      type = with types; nullOr (enum ["sddm" "gdm" "tuigreet" "regreet" "ly"]);
      default = null;
      example = "sddm";
      description = mdDoc "Choose the preferred display-manager.";
    };

    hidpi = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable hidpi display resolution.";
        };
      };
      default = {};
    };
  };

  config = mkMerge [
    (mkIf (cfg.displayManager == "gdm") {
      services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      programs.dconf.profiles.gdm.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = mkMerge [
              (mkIf (cfg.hidpi.enable) {
                scaling-factor = lib.gvariant.mkUint32 2;
              })
              (mkIf (!cfg.hidpi.enable) {
                scaling-factor = lib.gvariant.mkUint32 1;
              })
            ];
          };
        }
      ];
    })

    (mkIf (cfg.displayManager == "sddm") {
      services.displayManager.sddm = {
        enable = true;
        package = lib.mkForce pkgs.kdePackages.sddm;
        wayland.enable = true;
        settings = mkMerge [
          {
            Theme = {
              CursorTheme = "BreezeX-Dark";
              FacesDir = "/var/lib/AccountsService/icons";
            };
          }
          (mkIf (cfg.hidpi.enable) {
            Theme.CursorSize = 48; #BreezeX has problems with using 56px for some reason
            General.GreeterEnvironment = "QT_SCALE_FACTOR=2";
          })
          (mkIf (!cfg.hidpi.enable) {
            Theme.CursorSize = 24;
            General.GreeterEnvironment = "QT_SCALE_FACTOR=1";
          })
        ];
      };
    })

    (mkIf (cfg.displayManager == "tuigreet") {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format %d-%h-%Y-%I:%M%P --user-menu --remember --remember-session --asterisks --cmd ${pkgs.cage}/bin/cage";
            user = "greeter";
          };
        };
      };
    })

    (mkIf (cfg.displayManager == "regreet") {
      tintednix.gtkTheme.enable = true;
      programs.regreet = {
        enable = true;
        settings = {
          background = {
            path = ./login-background-nixos.png;
          };
        };
        theme = {
          name = config.nixos.desktop.theme.gtkTheme.name;
          package = config.nixos.desktop.theme.gtkTheme.package;
        };
        extraCss = builtins.readFile ./regreet/style.css;
        iconTheme = {
          name = config.nixos.desktop.theme.iconTheme.name;
          package = config.nixos.desktop.theme.iconTheme.package;
        };
        cursorTheme = {
          name = config.nixos.desktop.theme.cursorTheme.name;
          package = config.nixos.desktop.theme.cursorTheme.package;
        };
        font = {
          name = config.nixos.desktop.theme.fonts.defaultMonospace;
        };
      };
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = lib.mkForce "${pkgs.hyprland}/bin/hyprland --config /etc/greetd/hyprland.conf";
            user = "greeter";
          };
        };
      };
      environment.etc."greetd/hyprland.conf".text = ''
        exec-once = ${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit
        animations {
          enabled=false
        }
        monitor=DP-1, highres@highrr,1920x0,1
        monitor=DP-2, highres@highrr,3840x0,1
        monitor=HDMI-A-1, 3840x2160@60,0x0,2,bitdepth,10
        monitor=HDMI-A-2, highres@highrr,5760x0,1
        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          disable_hyprland_qtutils_check = true
        }
        decoration {
          blur {
            enabled = false;
          }
        }
        dwindle {
          preserve_split=yes
          pseudotile=yes
        }
        general {
          layout=dwindle
          resize_on_border=true
        }
        env=XCURSOR_SIZE,24
        env=HYPRCURSOR_SIZE,24
        env=HYPRCURSOR_THEME,BreezeX-Dark
        env=XCURSOR_THEME,BreezeX-Dark
        env=GDK_BACKEND,wayland,x11,*
        env=GDK_SCALE,2
        env=XDG_SESSION_TYPE,wayland
        bindm=SUPER, mouse:273, resizewindow
        bindm=SUPER, mouse:272, movewindow
        bind=SUPER CTRL, F, fullscreen
        bind=SUPER CTRL, S, togglesplit
      '';
    })

    (mkIf (cfg.displayManager == "ly") {
      services.displayManager.ly = {
        enable = true;
        settings = {
          save = true;
          animation = "matrix";
          clock = "%c";
        };
      };
    })
  ];
}
