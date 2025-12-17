{
  pkgs,
  config,
  lib,
  ...
}: let
  umpvFromClipboard = import ../../multimedia/mpv/wrappers/umpvFromClipboard.nix {inherit pkgs;};
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";

  binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
  mod = "SUPER";
  mvfocus = binding mod "movefocus";
  swapactive = binding "${mod} CTRL" "swapwindow";
  ws = binding mod "workspace";
  resizeactive = binding "${mod} SHIFT" "resizeactive";
  mv2ws = binding "${mod} SHIFT" "movetoworkspace";
  wsarr = [1 2 3 4 5 6 7 8 9];
  resetZoom = binding "${mod} SHIFT" "exec";

  gamemode = "${import ../../gaming/gamemode.nix {inherit config pkgs;}}/bin/gamemode";

  hyprsunsetToggle = import ../hyprsunset/hyprsunsetToggle.nix {inherit config lib pkgs;};

  wallpaperCycleToggle = import ../../utilities/wallpaper/${config.hm.wallpaper.daemon}/cycleToggle.nix {inherit config pkgs;};
  wallpaperSortToggle = import ../../utilities/wallpaper/${config.hm.wallpaper.daemon}/sortToggle.nix {inherit config pkgs;};
  wallpaperCycleStep =
    if config.hm.wallpaper.daemon == "hyprpaper"
    then "${import ../../utilities/wallpaper/${config.hm.wallpaper.daemon}/cycleStep.nix {inherit pkgs;}}/bin/hyprpapercyclestep"
    else "wpaperctl";
in {
  config = lib.mkIf config.hm.hyprland.enable {
    home.packages = with pkgs; [
      hyprpicker
      slurp #For selecting region of the screen
      grim #Screenshotter
      adw-gtk3
      wl-gammactl
      jq # for zoom bindings
    ];

    wayland.windowManager.hyprland = {
      settings = {
        binds = {
          allow_workspace_cycles = true;
          workspace_center_on = 1;
        };

        bind =
          [
            "${mod}, W, exec, [workspace 1] uwsm app -- ${config.hm.browsers.defaultBrowser}"
            "${mod}, F, exec, uwsm app -- alacritty -T Yazi -e yazi"
            "${mod}, E, exec, uwsm app -- alacritty"
            "${mod}, C, exec, uwsm app -- alacritty -T NVIM -e nvim"

            ''${mod} ALT, C, exec, uwsm app -- alacritty -T NVIM -e sh -c "wl-paste | nvim -"''
            "${mod}, R, exec, walker"
            "${mod}, N, exec, swaync-client -t" #Show sway control-center

            ''${mod}, P, exec, ${
                if config.hm.ironbar.enable
                then "${import ../../ironbar/config/customModules/tools/updatePickedColor.nix pkgs}"
                else "hyprpicker -a"
              }''

            ''${mod}, S, exec, uwsm app -- grim -g "$(slurp -o -c $(echo $base0D | sed 's/^....\(......\)/\1/') && sleep 0.3)" -t ppm - | satty --filename -''
            "${mod}, V, exec, uwsm app -- ${umpvFromClipboard}/bin/umpv-from-clipboard"
            "${mod}, M, exec, uwsm app -- tauon"

            "ALT, Q, killactive"

            "${mod} ALT, W, submap, Wallpaper 󰸉"
            "${mod} ALT, G, submap, Group 󰓩"

            (mvfocus "k" "u")
            (mvfocus "j" "d")
            (mvfocus "l" "r")
            (mvfocus "h" "l")
            (ws "left" "e-1")
            (ws "right" "e+1")
            (mv2ws "left" "e-1")
            (mv2ws "right" "e+1")
            (swapactive "k" "u")
            (swapactive "j" "d")
            (swapactive "l" "r")
            (swapactive "h" "l")

            "ALT, Tab, focuscurrentorlast"
            "${mod} CTRL, G, togglefloating"
            "${mod} CTRL, F, fullscreen"
            "${mod} CTRL, S, togglesplit"

            "${mod}, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')"
            "${mod}, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')"
            (resetZoom "mouse_up" "hyprctl -q keyword cursor:zoom_factor 1") #While holding Mod + Shift, scrolling the mouse wheel up resets the cursor zoom factor to 1 (neutral size).
            (resetZoom "mouse_down" "hyprctl -q keyword cursor:zoom_factor 1") #While holding Mod + Shift, scrolling the mouse wheel down resets the cursor zoom factor to 1.
            (resetZoom "minus" "hyprctl -q keyword cursor:zoom_factor 1") #Pressing Mod + Shift + - forces the cursor zoom factor back to 1.
          ]
          ++ (map (i: ws (toString i) (toString i)) wsarr)
          ++ (map (i: mv2ws (toString i) (toString i)) wsarr);

        bindr = [
          "CTRL ALT, Delete, exec, loginctl terminate-user $(whoami)"
        ];

        binde = [
          (resizeactive "k" "0 -20")
          (resizeactive "j" "0 20")
          (resizeactive "l" "20 0")
          (resizeactive "h" "-20 0")

          "${mod}, equal, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.3')" #Increases the cursor zoom factor by 10% when you press Mod + =. It reads the current numeric value, multiplies it by 1.1, and sets the new zoom level.
          "${mod}, minus, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.7) | if . < 1 then 1 else . end')" #Decreases the cursor zoom factor by 10% when you press Mod + -. The value is multiplied by 0.9 but clamped so it never goes below 1.
        ];

        bindm = [
          "${mod}, mouse:273, resizewindow"
          "${mod}, mouse:272, movewindow"
        ];

        bindle = [
          ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
          ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
          ",XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
          ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
        ];

        bindl =
          [
            ",XF86AudioPlay,    exec, ${playerctl} play-pause"
            ",XF86AudioStop,    exec, ${playerctl} pause"
            ",XF86AudioPause,   exec, ${playerctl} pause"
            ",XF86AudioPrev,    exec, ${playerctl} previous"
            ",XF86AudioNext,    exec, ${playerctl} next"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
            "SUPER, F1, exec, ${gamemode}"
          ]
          ++ lib.optionals (config.hm.hyprland.hyprsunset.enable) [
            "${mod} ALT, B, submap, Nightlight "
          ];
      };

      submaps = {
        "Group 󰓩" = {
          settings = {
            bind =
              [
                "SUPER, G, togglegroup"
                "SUPER, left, changegroupactive, b"
                "SUPER, right, changegroupactive, f"
              ]
              ++ (lib.map (i: "SUPER, ${i}, changegroupactive, ${i}") ["1" "2" "3" "4" "5" "6" "7"])
              ++ [
                "SUPER, L, lockgroups, toggle"
                "SUPER ALT, G, submap, reset"
                "SUPER, ESCAPE, submap, reset"
              ];
          };
        };
        "Wallpaper 󰸉" = {
          settings = {
            bind = [
              "SUPER, W, exec, ${wallpaperCycleToggle}"
              "SUPER, left, exec, ${wallpaperCycleStep} previous"
              "SUPER, right, exec, ${wallpaperCycleStep} next"
              "SUPER, S, exec, ${wallpaperSortToggle}"
              "SUPER ALT, W, submap, reset"
              "SUPER, ESCAPE, submap, reset"
            ];
          };
        };
        "Nightlight " = {
          settings = {
            bindl = [
              "SUPER, B, exec, ${hyprsunsetToggle}"
              "SUPER ALT, B, submap, reset"
              "SUPER, ESCAPE, submap, reset"
            ];
            bindle = [
              "SUPER, left, exec, hyprctl hyprsunset temperature -100))"
              "SUPER, right, exec, hyprctl hyprsunset temperature +100))"
            ];
          };
        };
      };
    };
  };
}
