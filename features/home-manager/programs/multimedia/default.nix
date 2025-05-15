{
  config,
  lib,
  ...
}: {
  programs.mpv = {
    enable = true;

    # Global settings that apply to all profiles
    config = {
      hwdec = "auto";
      scale = "ewa_lanczossharp";
      cscale = "mitchell";
      sigmoid-upscaling = "yes";
      dither-depth = "auto";
      save-position-on-quit = "yes";
      sub-font-size = 50;
      sub-color = "#FFFFFF";
      sub-border-size = 2.5;
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
        gpu-api = "vulkan";
        gpu-context = "waylandvk";
        target-trc = "pq";
      };
    };
  };
}
