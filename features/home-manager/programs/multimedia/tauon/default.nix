{
  config,
  lib,
  pkgs,
  ...
}: let
  configFile = import ./tauonConf.nix {inherit config;};
  ensureWriteable = import ../../../utils/ensureWriteable.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    tauon
  ];

  xdg.dataFile."TauonMusicBox/tauon.conf".source = (pkgs.formats.toml {}).generate "tauon.toml" configFile;
  systemd.user.services = {
    ensureTauonConfWriteable = {
      Unit = {
        Description = "Replace file with writeable version if not";
        Requires = ["wayland-wm@Hyprland.service"];
        After = ["wayland-wm@Hyprland.service"];
        # Stop this unit when hyprland stops
        PartOf = "wayland-wm@Hyprland.service";
        StartLimitBurst = "5";
        StartLimitIntervalSec = "60";
      };
      Service = {
        Type = "simple";
        ExecStart = "${ensureWriteable} ${config.home.homeDirectory}/.local/share/TauonMusicBox/tauon.conf";
        Restart = "on-failure";
        RestartSec = "2";
        TimeoutStartSec = "30s";
      };
      Install = {
        WantedBy = ["wayland-wm@Hyprland.service"];
      };
    };
  };
}
