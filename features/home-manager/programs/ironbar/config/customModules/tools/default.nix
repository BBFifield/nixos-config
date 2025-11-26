{
  config,
  lib,
  pkgs,
}: let
  gamemode = "${import ../../../../gaming/gamemode.nix {inherit config pkgs;}}/bin/gamemode";
  hyprsunsetToggle = import ./../../../../hyprland/hyprsunset/hyprsunsetToggle.nix {inherit config lib pkgs;};
  wallpaperCycleToggle = import ../../../../wallpaper/${config.hm.wallpaper.daemon}/cycleToggle.nix {inherit config pkgs;};
  wallpaperCycleStep =
    if config.hm.wallpaper.daemon == "hyprpaper"
    then "${import ../../../../wallpaper/${config.hm.wallpaper.daemon}/cycleStep.nix {inherit pkgs;}}/bin/hyprpapercyclestep"
    else "wpaperctl";
in ''
  $tools_popup = {
    type = "custom"
    name = "tools"
    bar = [
      {
        type = "button"
        label = ""
        on_click = "popup:toggle"
      }
    ]
    popup = [
      {
        type = "box"
        orientation = "vertical"
        widgets = [
          {
            type = "button"
            name = "colorPicker"
            class = "tool"
            label = "󰌁"
            on_click = "!${import ./updatePickedColor.nix pkgs}"
            tooltip = "#picked_color"
          }
          {
            type = "box"
            orientation = "horizontal"
            halign = "center"
            widgets = [
              {
                type = "button"
                name = "nightLightToggle"
                class = "tool"
                label = "#night_light_icon"
                on_click = "!${hyprsunsetToggle}"
                tooltip = "Night Light #night_light_status"
              }
              {
                type = "slider"
                name = "nightLightSlider"
                show_label = true
                show_if = "#show_night_light_slider"
                length = 100
                min = ${lib.elemAt config.hm.hyprland.hyprsunset.range 0}
                max = ${lib.elemAt config.hm.hyprland.hyprsunset.range 1}
                on_change="!hyprctl hyprsunset temperature \"''${0%.*}\";"
                value = "5000:hyprctl hyprsunset temperature"
              }
            ]
          }
          {
            type = "button"
            name = "screenshotter"
            class = "tool"
            label = "󰹑"
            on_click = "!grim -g \"$(slurp -o -c $(echo $(ironbar var get base0D) | sed 's/^....\\(......\\)/\\1/') && sleep 0.3)\" -t ppm - | satty --filename -"
            tooltip = "Take Screenshot"
          }
          {
            type = "box"
            orientation = "horizontal"
            halign = "center"
            widgets = [
              {
                type = "button"
                name = "wallpaperCycleToggle"
                class = "tool"
                label = "󰸉"
                on_click = "!${wallpaperCycleToggle}"
                tooltip = "#wallpaper_cycle_status"
              }
              {
                type = "box"
                orientation = "horizontal"
                halign = "center"
                name = "wallpaperNavButtons"
                class = "linked"
                widgets = [
                  {
                    type = "button"
                    class = "wallpaperNav"
                    name = "wallpaperPrevious"
                    label = ""
                    on_click="!${wallpaperCycleStep} previous"
                    tooltip = "Previous wallpaper"
                  }
                  {
                    type = "button"
                    class = "wallpaperNav"
                    name = "wallpaperNext"
                    label = ""
                    on_click="!${wallpaperCycleStep} next"
                    tooltip = "Next wallpaper"
                  }
                ]
              }
            ]
          }
          {
            type = "box"
            orientation = "horizontal"
            halign = "center"
            widgets = [
              {
                type = "button"
                name = "gamemodeToggle"
                class = "tool"
                label = ""
                on_click = "!${gamemode}"
                tooltip = "Gamemode #gamemode_status"
              }
            ]
          }
        ]
      }
    ]
  }
''
