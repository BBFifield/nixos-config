# Use command "fc-list : family style" to see a list of fonts on your system.
{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop.theme;

  nfAttrs = {
    fira-code = {name = "FiraCode Nerd Font";};
    victor-mono = {name = "VictorMono Nerd Font";};
    iosevka-term = {name = "IosevkaTerm Nerd Font";};
    jetbrains-mono = {name = "JetBrainsMono Nerd Font";};
    iosevka = {name = "Iosevka Nerd Font";};
    roboto-mono = {name = "RobotoMono Nerd Font";};
    caskaydia-cove = {name = "CaskaydiaCove Nerd Font Mono";};
  };
  nfToFetch = builtins.attrNames nfAttrs;
  nfEnums = with builtins; attrValues (mapAttrs (name: value: value.name) nfAttrs);

  fontsSubmodule = types.submodule {
    options = {
      defaultMonospace = mkOption {
        type = types.enum nfEnums;
        default = "JetBrainsMono Nerd Font";
      };
    };
  };
in {
  options.nixos.desktop.theme = {
    fonts = mkOption {
      type = fontsSubmodule;
      default = {
        defaultMonospace = "JetBrainsMono Nerd Font";
      };
    };
  };

  config = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [cfg.fonts.defaultMonospace];
    };

    fonts.packages = with pkgs; let
      nfPkgs = lib.map (nf: nerd-fonts.${nf}) nfToFetch;
    in
      nfPkgs ++ [iosevka fonts.ds-digital];
  };
}
