{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.nixos.desktop;
in {
  imports = [
    ./session.nix
    ./display-manager.nix
    ./look-and-feel
  ];

  config = lib.mkMerge [
    {
      # Specifies the default terminal program to execute when opening terminal-based programs from launchers.
      xdg.terminal-exec = {
        enable = true;
        settings = {
          default = ["Alacritty.desktop"];
        };
      };
    }

    (lib.mkIf (cfg.plasma.enable && !cfg.gnome.enable) {
      warnings =
        if cfg.displayManager != "sddm"
        then [
          ''
            You have set the display-manager to ${cfg.displayManager}. It is recommended to set it to "sddm" when "plasma" is enabled.
          ''
        ]
        else [];
      services.displayManager.sddm = lib.mkForce {
        wayland.compositor = "kwin";
        theme = "breeze";
      };
    })

    (lib.mkIf (cfg.gnome.enable) {
      warnings =
        if cfg.displayManager != "gdm"
        then [
          ''
            You have set the display-manager to ${cfg.displayManager}. It is recommended to set it to "gdm" when "gnome" is enabled, otherwise problems with the lockscreen may occur.
          ''
        ]
        else [];
    })

    (lib.mkIf (cfg.hyprland.enable) (
      lib.mkMerge [
        {
          assertions = [
            {
              assertion = cfg.displayManager != "gdm";
              message = "You have set the display-manager to ${cfg.displayManager}. GDM may cause hyprland to crash on first launch.";
            }
          ];
        }
        (lib.mkIf (cfg.displayManager == "sddm") {
          services.displayManager.sddm = {
            wayland.compositor = "weston";
            theme = "catppuccin-frappe";
          };

          environment.systemPackages = [
            (
              pkgs.catppuccin-sddm.override {
                flavor = "frappe";
                font = cfg.theme.fonts.defaultMonospace;
                fontSize = "11";
              }
            )
          ];
        })
      ]
    ))
  ];
}
