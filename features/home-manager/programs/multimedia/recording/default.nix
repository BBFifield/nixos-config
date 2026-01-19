{pkgs, ...}: {
  imports = [./hybrid];

  home.packages = with pkgs; [
    v4l-utils
    handbrake
    avidemux
    ffmpeg
    alsa-utils
    usbutils
  ];
  programs.obs-studio.enable = true;

  xdg.configFile."ghb/presets.json".source = ./handbrake/presets.json;

  # unset QT_QPA_PLATFORM ; QT_SCALE_FACTOR=2 appimage-run /home/brandon/Downloads/Hybrid-2026.01.02.1-x86_64.AppImage
}
