{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.ironbar;

  sassFile = import ./config/style.nix config pkgs;
  compiledSassFile =
    pkgs.runCommand "style_ironbar" {nativeBuildInputs = with pkgs; [dart-sass jq];}
    ''
      #!/usr/bin/env bash
      mkdir -p $out
      cat > "$out/styleIronbar.scss" <<'EOF'
      ${sassFile}
      EOF
      sass "$out/styleIronbar.scss" "$out/.config/ironbar/style.css"
    '';
in {
  options.hm.ironbar = {
    enable = lib.mkEnableOption "Enable ironbar statusbar.";
    customModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      # default = ["walker" "tools" "stats" "network" "power"];
      default = ["walker" "tools" "stats" "power"];
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [compiledSassFile pkgs.networkmanagerapplet pkgs.networkmanager];
        xdg.configFile."ironbar/style.css" = {
          source = "${compiledSassFile}/.config/ironbar/style.css";
          # source = compiledSassFile;
          onChange = ''
            ${config.programs.ironbar.package}/bin/ironbar style load-css "/home/$(whoami)/.config/ironbar/style.css"
          '';
        };
        xdg.configFile."ironbar/config.corn".text = import ./config/config.nix {inherit config pkgs lib;};
      }
      {
        systemd.user.services = {
          ironbar-post-start = {
            Unit = {
              Description = "Run post-start setup for Ironbar";
              Requires = ["ironbar.service"];
              After = ["ironbar.service"];
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${(import ./postStart.nix {inherit config pkgs;})}/bin/ironbar_post_start";
              RemainAfterExit = true;
            };
            Install = {
              WantedBy = ["ironbar.service"];
            };
          };
          ironbar-stats = {
            Unit = {
              Description = "Hooks into ironbar IPC to provide live system stats";
              Requires = ["ironbar.service"];
              After = ["ironbar.service"];
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${pkgs.bash}/bin/bash ${./config/customModules/stats/stats.sh}";
              RemainAfterExit = true;
            };
            Install = {
              WantedBy = ["ironbar.service"];
            };
          };
        };
      }
      {
        hm.swaync.enable = true;

        home.packages = with pkgs; [
          playerctl
        ];

        programs.ironbar = {
          enable = true;
          systemd = false;
        };
      }
    ]
  );
}
