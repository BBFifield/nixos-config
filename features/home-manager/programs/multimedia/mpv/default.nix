{
  pkgs,
  config,
  lib,
  ...
}: let
  mpvHDRwrapper = import ./wrappers/mpvHDRwrapper.nix {inherit pkgs;};
in {
  options.hm.mpv = {
    enable = lib.mkEnableOption "Enable MPV video player.";
    enableScripts = lib.mkEnableOption "Enable UOSC (User On-Screen Controller) and related scripts.";
  };
  config = lib.mkIf config.hm.mpv.enable {
    home.packages = with pkgs; [
      yt-dlp
      deno #required by yt-dlp these days, fuck google
    ];

    xdg.configFile."mpv/script-opts".source = ./config/thumbfast.conf;

    xdg = {
      desktopEntries.mpv = {
        type = "Application";
        name = "mpv Media Player";
        genericName = "Multimedia player";
        comment = "Play videos in HDR mode";
        icon = "mpv";
        exec = "${mpvHDRwrapper}/bin/mpv-hdr %U";
        categories = [
          "AudioVideo"
          "Audio"
          "Video"
          "Player"
          "TV"
        ];
        mimeType = import ./config/mimeTypes.nix {};
        settings = {
          Keywords = "mpv;media;player;video;audio;tv";
        };
      };
      mimeApps.defaultApplications = {
        "video/mp4" = ["mpv.desktop"];
        "video/webm" = ["mpv.desktop"];
        "video/ogg" = ["mpv.desktop"];
        "video/x-msvideo" = ["mpv.desktop"]; # AVI files
        "video/quicktime" = ["mpv.desktop"]; # MOV files
        "video/mpeg" = ["mpv.desktop"];
        "video/x-matroska" = ["mpv.desktop"]; # MKV files
        "video/x-flv" = ["mpv.desktop"]; # FLV files
        "video/3gpp" = ["mpv.desktop"];
        "video/3gpp2" = ["mpv.desktop"];
      };
    };

    programs.mpv = {
      enable = true;
      package = pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped.overrideAttrs (oldAttrs: {
          patches =
            (oldAttrs.patches or [])
            ++ [
              ./config/umpv-replace.patch # patch is necessary to get the behaviour we want (immediate feedback on youtube links)
            ];
        });
        scripts =
          if config.hm.mpv.enableScripts
          then (with pkgs.mpvScripts; [uosc sponsorblock thumbfast])
          else [];
      };

      # Global settings that apply to all profiles
      config =
        {
          hwdec = "auto-safe";
          scale = "ewa_lanczossharp";
          cscale = "mitchell";
          sigmoid-upscaling = "yes";
          dither-depth = "auto";
          save-position-on-quit = "yes";
          sub-font-size = 50;
          sub-color = ''#FFFFFF'';
          sub-border-size = 2.5;
          force-window = "immediate"; # Provides instant feedback when loading youtube vids
          ytdl = "yes";
          ytdl-format = "best[protocol!=m3u8][vcodec!=av1]/best"; #Prefer hw-decodable streams (avoid AV1 WebM since there's no hwdec for it on 1070 ti)
        }
        // lib.optionalAttrs config.hm.mpv.enableScripts {osd-bar = "no";}; #uosc provides seeking & volume indicators (via flash-timeline and flash-volume commands)

      # Profile-specific settings
      profiles = {
        HDR_Display = lib.mkIf config.wayland.windowManager.hyprland.settings.experimental.xx_color_management_v4 {
          # These mpv options have to be loaded before MPV loads auto-profiles, so this won't work via a condition definition. Profile loaded explicitly via script instead.
          # HDR-specific video settings
          vo = "gpu-next";
          target-colorspace-hint = "yes";
          gpu-api = "vulkan";
          gpu-context = "waylandvk";
        };
        /*
        Might require a stop of pipewire service so mpv can claim the alsa device: systemctl --user stop pipewire pipewire-pulse
        */
        audio_DolbyAtmos = {
          profile-desc = "Dolby Atmos";
          profile-cond = ''(filename or ""):lower():match("%f[%w]atmos%f[%W]")''; #frontier patterns to require word boundaries so "Atmos/atmos" won't match inside other words
          profile-restore = "copy";
          ao = "alsa"; # ALSA audio output
          audio-device = "alsa/hdmi:CARD=NVidia,DEV=0"; # mpv --audio-device=help
          audio-exclusive = "yes";
          audio-channels = "auto";
          audio-spdif = "eac3,truehd";
        };
      };
    };
  };
}
