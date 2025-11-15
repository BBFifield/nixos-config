{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      yt-dlp
      deno #required by yt-dlp these days, fuck google
    ];
    xdg.mimeApps.defaultApplications = {
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

    programs.mpv = {
      enable = true;
      package = (
        pkgs.mpv-unwrapped.wrapper {
          mpv = pkgs.mpv-unwrapped;
          scripts = with pkgs.mpvScripts; [
            uosc
            sponsorblock
            thumbfast
          ];
        }
      );
      # Global settings that apply to all profiles
      config = {
        hwdec = "auto-safe";
        scale = "ewa_lanczossharp";
        cscale = "mitchell";
        sigmoid-upscaling = "yes";
        dither-depth = "auto";
        save-position-on-quit = "yes";
        sub-font-size = 50;
        sub-color = ''#FFFFFF'';
        sub-border-size = 2.5;
        ytdl = "yes";
        ytdl-format = "best[protocol!=m3u8][vcodec!=av1]/best"; #Prefer hw-decodable streams (avoid AV1 WebM since there's no hwdec for it on 1070 ti)
      };

      # Profile-specific settings, applied conditionally
      profiles = {
        HDR_Display = lib.mkIf config.wayland.windowManager.hyprland.settings.experimental.xx_color_management_v4 {
          profile-cond = let
            # Filter HDR-capable displays
            hdrOutputs = lib.filterAttrs (_: value: value.isHDRcapable or false) config.hm.hyprland.displayOutputs;

            # Generate Lua conditions for HDR-capable displays
            hdrConditions = builtins.concatStringsSep " or " (map (output: ''string.match(mp.get_property("display-names"), "${output}")'') (builtins.attrNames hdrOutputs));
          in
            hdrConditions;

          # HDR-specific video settings
          vo = "gpu-next";
          target-colorspace-hint = "yes";
          # target-colorspace-hint-mode = "source";
          gpu-api = "vulkan";
          gpu-context = "waylandvk";
          target-trc = "pq";
        };
      };
    };
    xdg.configFile."mpv/script-opts/uosc.conf".source = ./uosc.conf;
  };
}
