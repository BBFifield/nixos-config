{
  self,
  system,
  lib,
  inputs,
  ...
}: {
  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = f: _p: {
    stable = import inputs.nixpkgs-stable {
      system = f.system;
      config.allowUnfree = true;
    };
  };

  uboot = f: p: {
    ubootRaspberryPi2 = p.ubootRaspberryPi2.overrideAttrs (oldAttrs: {
      extraConfig = ''
        CONFIG_AUTOBOOT=y
        CONFIG_AUTOBOOT_KEYED=y
        CONFIG_AUTOBOOT_STOP_STR="\x0b"
        CONFIG_AUTOBOOT_KEYED_CTRLC=y
        CONFIG_AUTOBOOT_PROMPT="autoboot in 1 second (hold 'CTRL^C' to abort)\n"
        CONFIG_BOOT_RETRY_TIME=15
        CONFIG_RESET_TO_RETRY=y
      '';
    });
  };

  customPkgs = f: p:
    lib.pathToAttrs "${self}/pkgs" (full_path: _: p.callPackage full_path {});

  firefox-native-base16 = f: p: {
    firefox-base16 = inputs.firefox-native-base16.packages.${system}.default;
  };

  nonFlakeSrcs = f: p: {
    inherit (inputs) neovim-config;
    inherit (inputs) firefox-gnome-theme;
    inherit (inputs) wavefox;
    tintednix = f.callPackage inputs.tintednix {}; #Just to access the mustache file
  };
  ytDlp = f: p: {
    yt-dlp = p.yt-dlp.overrideAttrs (oldAttrs: {
      src = p.fetchFromGitHub {
        owner = "yt-dlp";
        repo = "yt-dlp";
        rev = "2025.10.22"; # new tag/commit
        sha256 = "sha256-jQaENEflaF9HzY/EiMXIHgUehAJ3nnDT9IbaN6bDcac=";
      };
    });
  };

  defaults = [
    inputs.nurpkgs.overlays.default
    inputs.alacritty-theme.overlays.default
    inputs.tintednix.overlays.default
    inputs.hyprland-contrib.overlays.default
  ];
}
