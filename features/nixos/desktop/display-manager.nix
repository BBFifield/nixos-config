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

    (let
      sassFile = import ./regreet/style.nix config pkgs;
      compiledSassFile =
        pkgs.runCommand "style_regreet" {nativeBuildInputs = with pkgs; [dart-sass jq];}
        ''
          #!/usr/bin/env bash
          mkdir -p $out
          cat > "$out/styleRegreet.scss" <<'EOF'
          ${sassFile}
          EOF
          sass "$out/styleRegreet.scss" "$out/.config/regreet/style.css"
        '';
    in
      mkIf (cfg.displayManager == "regreet") {
        tintednix.gtkTheme.enable = true;
        environment.systemPackages = [compiledSassFile];
        programs.regreet = {
          enable = true;
          settings = {
            background = {
              path = ../../../default-wallpaper/background-nixos.png;
            };
          };
          theme = {
            name = config.nixos.desktop.theme.gtkTheme.name;
            package = config.nixos.desktop.theme.gtkTheme.package;
          };
          extraCss = builtins.readFile "${compiledSassFile}/.config/regreet/style.css";
          # builtins.readFile ./regreet/style.css;
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
              # command = lib.mkForce "${pkgs.hyprland}/bin/hyprland --config /etc/greetd/hyprland.conf";
              command = "${pkgs.cage}/bin/cage -m last -s -d -- sh -c '${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --mode 3840x2160 --scale 2 && ${pkgs.regreet}/bin/regreet'";
              user = "greeter";
            };
          };
        };
        # environment.etc."greetd/hyprland.conf".text = ''
        #   exec-once = ${pkgs.regreet}/bin/regreet; hyprctl dispatch exit
        #   animations {
        #     enabled=false
        #   }
        #   monitor=DP-1, highres@highrr,1920x0,1
        #   monitor=DP-2, highres@highrr,3840x0,1
        #   monitor=HDMI-A-1, 3840x2160@60,0x0,2,bitdepth,10
        #   monitor=HDMI-A-2, highres@highrr,5760x0,1
        #   misc {
        #     disable_hyprland_logo = true
        #     disable_splash_rendering = true
        #     disable_hyprland_qtutils_check = true
        #   }
        #   decoration {
        #     blur {
        #       enabled = false;
        #     }
        #   }
        #   dwindle {
        #     preserve_split=yes
        #     pseudotile=yes
        #   }
        #   general {
        #     layout=dwindle
        #     resize_on_border=true
        #   }

        # Otherwise drives will be automounted by the greeter user
        environment.etc."polkit-1/rules.d/10-udisks2-seat-local.rules".text = ''
          polkit.addRule(function(action, subject) {
            if (action.id.indexOf("org.freedesktop.udisks2") === 0) {
              if (subject.user == "greeter") return polkit.Result.NO;
              if (subject.session && subject.session.active) return polkit.Result.YES;
              if (subject.local) return polkit.Result.YES;
              return polkit.Result.NO;
            }
          });
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
