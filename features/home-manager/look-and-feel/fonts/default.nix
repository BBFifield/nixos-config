{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.theme;

  nfAttrs = {
    victor-mono = {name = "VictorMono Nerd Font";};
    iosevka-term = {name = "IosevkaTerm Nerd Font";};
    jetbrains-mono = {name = "JetBrainsMono Nerd Font";};
    iosevka = {name = "Iosevka Nerd Font";};
    roboto-mono = {name = "RobotoMono Nerd Font";};
    caskaydia-cove = {name = "CaskaydiaCove Nerd Font Mono";};
    fira-code = {name = "FiraCode Nerd Font";};
  };
  nfToFetch = lib.attrNames nfAttrs;
  nfEnums = lib.attrValues (lib.mapAttrs (name: value: value.name) nfAttrs);
  fontsSubmodule = lib.types.submodule {
    options = {
      defaultMonospace = lib.mkOption {
        type = lib.types.enum nfEnums;
        default = "JetBrainsMono Nerd Font";
      };
    };
  };
in {
  options.hm.theme = with lib; {
    fonts = mkOption {
      type = fontsSubmodule;
    };
  };

  config = lib.mkMerge [
    {
      fonts.fontconfig = {
        enable = true;
        defaultFonts.monospace = [cfg.fonts.defaultMonospace];
      };

      home.packages = with pkgs; let
        nfPkgs = lib.map (nf: nerd-fonts.${nf}) nfToFetch;
      in
        nfPkgs
        ++ [fonts.ds-digital];
    }
  ];
}
