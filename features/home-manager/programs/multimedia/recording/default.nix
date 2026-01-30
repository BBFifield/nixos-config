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

  /*
  Recording with ffmpeg
  https://vsbogd.github.io/misc/howto-capture-vhs.html
  https://github.com/danyfernandes/vhs-capture-pinnacle-linux
  */
  # nix-shell -p alsa-utils v4l-utils usbutils
  # export VIDEO=/dev/video0
  # export AUDIO=hw:3
  # v4l2-ctl --device $VIDEO --set-ctl mute=0
  # amixer -D $AUDIO set Line 16
  #
  # ffmpeg -ar 44100 -thread_queue_size 1024 -f alsa -i $AUDIO -r 29.97 -thread_queue_size 1024 -i $VIDEO -codec:v ffv1 -codec:a pcm_s16le 70thBirth_preview.mkv

  /*
  Executing hybrid AppImage
  */
  # unset QT_QPA_PLATFORM ; QT_SCALE_FACTOR=2 appimage-run /home/brandon/Downloads/Hybrid-2026.01.02.1-x86_64.AppImage
}
