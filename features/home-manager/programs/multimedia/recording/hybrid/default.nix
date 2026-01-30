{
  config,
  pkgs,
  ...
}: let
  extraConfigTxt = ''
    vapoursynth=true
    avisynthOnLinux=true
  '';

  vsplugins = with pkgs; [
    (callPackage ./pkgs/eedi3.nix {})
    (callPackage ./pkgs/lsmashsource.nix {})
    (callPackage ./pkgs/fft3d.nix {})
    vapoursynthPlugins.fmtconv
    vapoursynthPlugins.removegrain
    vapoursynth-nnedi3
    vapoursynth-znedi3
    vapoursynth-mvtools
  ];
in {
  home.packages = with pkgs; [
    avisynthplus
    vapoursynth
    (callPackage ./pkgs/hybrid.nix {inherit extraConfigTxt vsplugins;})
  ];

  # unset QT_QPA_PLATFORM ; QT_SCALE_FACTOR=2 appimage-run /home/brandon/Downloads/Hybrid-2026.01.02.1-x86_64.AppImage
}
