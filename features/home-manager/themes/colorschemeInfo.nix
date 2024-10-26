{
  catppuccin = rec {
    variants = {
      mocha = {
        palette = rec {
          rosewater = "f5e0dc"; #f5e0dc
          flamingo = "f2cdcd"; #f2cdcd
          pink = "f5c2e7"; #f5c2e7
          mauve = "cba6f7"; #cba6f7
          red = "f38ba8"; #f38ba8
          maroon = "eba0ac"; #eba0ac
          peach = "fab387"; #fab387
          yellow = "f9e2af"; #f9e2af
          green = "a6e3a1"; #a6e3a1
          teal = "94e2d5"; #94e2d5
          sky = "89dceb"; #89dceb
          sapphire = "74c7ec"; #74c7ec
          blue = "89b4fa"; #89b4fa
          lavender = "b4befe"; #b4befe
          text = "cdd6f4"; #cdd6f4
          subtext1 = "bac2de"; #bac2de
          subtext0 = "a6adc8"; #a6adc8
          overlay2 = "9399b2"; #9399b2
          overlay1 = "7f849c"; #7f849c
          overlay0 = "6c7086"; #6c7086
          surface2 = "585b70"; #585b70
          surface1 = "45475a"; #45475a
          surface0 = "313244"; #313244
          base = "1e1e2e"; #1e1e2e
          mantle = "181825"; #181825
          crust = "11111b"; #11111b
          customBg = mantle;
          customText = blue;
          customBtnHoverBg = blue;
          customBtnHoverFg = mantle;
          customActiveWorkspace = red;
          customInactiveWorkspace = pink;
          customBgAlt = crust;
          customTextAlt = customText;
          customAccentPrimary = customText;
          customAccentSecondary = customBtnHoverBg;
        };
        mode = "dark";
      };
      macchiato = {
        palette = rec {
          rosewater = "f5e0dc"; #f5e0dc
          flamingo = "f2cdcd"; #f2cdcd
          pink = "f5c2e7"; #f5c2e7
          mauve = "cba6f7"; #cba6f7
          red = "f38ba8"; #f38ba8
          maroon = "eba0ac"; #eba0ac
          peach = "fab387"; #fab387
          yellow = "f9e2af"; #f9e2af
          green = "a6e3a1"; #a6e3a1
          teal = "94e2d5"; #94e2d5
          sky = "89dceb"; #89dceb
          sapphire = "74c7ec"; #74c7ec
          blue = "89b4fa"; #89b4fa
          lavender = "b4befe"; #b4befe
          text = "cdd6f4"; #cdd6f4
          subtext1 = "bac2de"; #bac2de
          subtext0 = "a6adc8"; #a6adc8
          overlay2 = "9399b2"; #9399b2
          overlay1 = "7f849c"; #7f849c
          overlay0 = "6c7086"; #6c7086
          surface2 = "585b70"; #585b70
          surface1 = "45475a"; #45475a
          surface0 = "313244"; #313244
          base = "1e1e2e"; #1e1e2e
          mantle = "181825"; #181825
          crust = "11111b"; #11111b
          customBg = base;
          customText = blue;
          customBtnHoverBg = blue;
          customBtnHoverFg = base;
          customActiveWorkspace = red;
          customInactiveWorkspace = pink;
          customBgAlt = customBg;
          customTextAlt = customText;
          customAccentPrimary = customText;
          customAccentSecondary = customBtnHoverBg;
        };
        mode = "dark";
      };
      frappe = {
        palette = rec {
          rosewater = "f2d5cf"; #f2d5cf
          flamingo = "eebebe"; #eebebe
          pink = "f4b8e4"; #f4b8e4
          mauve = "ca9ee6"; #ca9ee6
          red = "e78284"; #e78284
          maroon = "ea999c"; #ea999c
          peach = "ef9f76"; #ef9f76
          yellow = "e5c890"; #e5c890
          green = "a6d189"; #a6d189
          teal = "81c8be"; #81c8be
          sky = "99d1db"; #99d1db
          sapphire = "85c1dc"; #85c1dc
          blue = "8caaee"; #8caaee
          lavender = "babbf1"; #babbf1
          text = "c6d0f5"; #c6d0f5
          subtext1 = "b5bfe2"; #b5bfe2
          subtext0 = "a5adce"; #a5adce
          overlay2 = "949cbb"; #949cbb
          overlay1 = "838ba7"; #838ba7
          overlay0 = "737994"; #737994
          surface2 = "626880"; #626880
          surface1 = "51576d"; #51576d
          surface0 = "414559"; #414559
          base = "303446"; #303446
          mantle = "292c3c"; #292c3c
          crust = "232634"; #232634
          customBg = base;
          customText = blue;
          customBtnHoverBg = blue;
          customBtnHoverFg = base;
          customActiveWorkspace = red;
          customInactiveWorkspace = pink;
          customBgAlt = crust;
          customTextAlt = customText;
          customAccentPrimary = customText;
          customAccentSecondary = customBtnHoverBg;
        };
        mode = "dark";
      };
      latte = {
        palette = rec {
          rosewater = "dc8a78"; #dc8a78
          flamingo = "dd7878"; #dd7878
          pink = "ea76cb"; #ea76cb
          mauve = "8839ef"; #8839ef
          red = "d20f39"; #d20f39
          maroon = "e64553"; #e64553
          peach = "fe640b"; #fe640b
          yellow = "df8e1d"; #df8e1d
          green = "40a02b"; #40a02b
          teal = "179299"; #179299
          sky = "04a5e5"; #04a5e5
          sapphire = "209fb5"; #209fb5
          blue = "1e66f5"; #1e66f5
          lavender = "7287fd"; #7287fd
          text = "4c4f69"; #4c4f69
          subtext1 = "5c5f77"; #5c5f77
          subtext0 = "6c6f85"; #6c6f85
          overlay2 = "7c7f93"; #7c7f93
          overlay1 = "8c8fa1"; #8c8fa1
          overlay0 = "9ca0b0"; #9ca0b0
          surface2 = "acb0be"; #acb0be
          surface1 = "bcc0cc"; #bcc0cc
          surface0 = "ccd0da"; #ccd0da
          base = "eff1f5"; #eff1f5
          mantle = "e6e9ef"; #e6e9ef
          crust = "dce0e8"; #dce0e8
          customBg = base;
          customText = text;
          customBtnHoverBg = blue;
          customBtnHoverFg = base;
          customActiveWorkspace = blue;
          customInactiveWorkspace = teal;
          customBgAlt = "181825";
          customTextAlt = customText;
          customAccentPrimary = "303446";
          customAccentSecondary = customBtnHoverBg;
        };
        mode = "light";
      };
    };
    cognates = value: {
      activeBorder1 = variants.${value}.palette.mauve;
      activeBorder2 = variants.${value}.palette.rosewater;
      inactiveBorder1 = variants.${value}.palette.lavender;
      inactiveBorder2 = variants.${value}.palette.overlay0;
      text = variants.${value}.palette.customText;
      textField = variants.${value}.palette.surface0;
      bg = variants.${value}.palette.customBg;
      btnHoverBg = variants.${value}.palette.customBtnHoverBg;
      btnHoverFg = variants.${value}.palette.customBtnHoverFg;
      activeWorkspace = variants.${value}.palette.customActiveWorkspace;
      inactiveWorkspace = variants.${value}.palette.customInactiveWorkspace;
      failure = variants.${value}.palette.red;
      warning = variants.${value}.palette.yellow;
      blue = variants.${value}.palette.blue;
      red = variants.${value}.palette.red;
      purple = variants.${value}.palette.mauve;
      pink = variants.${value}.palette.pink;
      yellow = variants.${value}.palette.yellow;
      green = variants.${value}.palette.green;
      bgAlt = variants.${value}.palette.customBgAlt;
      textAlt = variants.${value}.palette.customTextAlt;
      accentPrimary = variants.${value}.palette.customAccentPrimary;
      accentSecondary = variants.${value}.palette.customAccentSecondary;
    };
  };
  dracula = rec {
    variants = {
      standard = {
        palette = rec {
          background = "282a36"; #282a36
          currentLine = "44475a"; #44475a
          foreground = "f8f8f2"; #f8f8f2
          comment = "6272a4"; #6272a4
          cyan = "8be9fd"; #8be9fd
          green = "50fa7b"; #50fa7b
          orange = "ffb86c"; #ffb86c
          pink = "ff79c6"; #ff79c6
          purple = "bd93f9"; #bd93f9
          red = "ff5555"; #ff5555
          yellow = "f1fa8c"; #f1fa8c
          customBg = background;
          customText = foreground;
          customBtnHoverBg = comment;
          customBtnHoverFg = foreground;
          customActiveWorkspace = purple;
          customInactiveWorkspace = comment;
          customBgAlt = customBg;
          customTextAlt = customText;
          customAccentPrimary = customText;
          customAccentSecondary = customBtnHoverBg;
        };
        mode = "dark";
      };
      alucard = {
        palette = rec {
          background = "f8f8f2"; #f8f8f2
          currentLine = "e2e4e5"; #e2e4e5
          foreground = "282a36"; #282a36
          comment = "6272a4"; #6272a4
          cyan = "8be9fd"; #8be9fd
          green = "50fa7b"; #50fa7b
          orange = "ffb86c"; #ffb86c
          pink = "ff79c6"; #ff79c6
          purple = "bd93f9"; #bd93f9
          red = "ff5555"; #ff5555
          yellow = "f1fa8c"; #f1fa8c
          customBg = currentLine;
          customText = foreground;
          customBtnHoverBg = comment;
          customBtnHoverFg = currentLine;
          customActiveWorkspace = red;
          customInactiveWorkspace = comment;
          customBgAlt = foreground;
          customTextAlt = customText;
          customAccentPrimary = customBgAlt;
          customAccentSecondary = customBtnHoverBg;
        };
        mode = "light";
      };
    };
    cognates = value: {
      activeBorder1 = variants.${value}.palette.pink;
      activeBorder2 = variants.${value}.palette.cyan;
      inactiveBorder1 = variants.${value}.palette.comment;
      inactiveBorder2 = variants.${value}.palette.currentLine;
      text = variants.${value}.palette.customText;
      textField = variants.${value}.palette.background;
      bg = variants.${value}.palette.customBg;
      btnHoverBg = variants.${value}.palette.customBtnHoverBg;
      btnHoverFg = variants.${value}.palette.customBtnHoverFg;
      activeWorkspace = variants.${value}.palette.customActiveWorkspace;
      inactiveWorkspace = variants.${value}.palette.customInactiveWorkspace;
      failure = variants.${value}.palette.red;
      warning = variants.${value}.palette.yellow;
      blue = variants.${value}.palette.cyan;
      red = variants.${value}.palette.red;
      purple = variants.${value}.palette.purple;
      pink = variants.${value}.palette.pink;
      yellow = variants.${value}.palette.yellow;
      green = variants.${value}.palette.green;
      bgAlt = variants.${value}.palette.customBgAlt;
      textAlt = variants.${value}.palette.customTextAlt;
      accentPrimary = variants.${value}.palette.customAccentPrimary;
      accentSecondary = variants.${value}.palette.customAccentSecondary;
    };
  };
  gruvbox = rec {
    variants = {
      dark = {
        palette = {
          bg = "282828"; #282828
          darkRed = "cc241d"; #cc241d
          red = "fb4934"; #fb4934
          darkGreen = "98971a"; #98971a
          green = "b8bb26"; #b8bb26
          darkYellow = "d79921"; #d79921
          yellow = "fabd2f"; #fabd2f
          darkBlue = "83a598"; #83a598
          blue = "458588"; #458588
          darkpurple = "b16286"; #b16286
          purple = "d3869b"; #d3869b
          darkGray = "928374"; #928374
          gray = "a89984"; #a89984
          darkAqua = "689d6a"; #689d6a
          aqua = "8ec07c"; #8ec07c
          fg = "ebdbb2"; #ebdbb2
          bg0_h = "1d2021"; #1d2021
          bg0 = "282828"; #282828
          bg1 = "3c3836"; #3c3836
          bg2 = "504945"; #504945
          bg3 = "665c54"; #665c54
          bg4 = "7c6f64"; #7c6f64
          orange = "d65d0e"; #d65d0e
          bg0_s = "32302f"; #32302f
          fg4 = "a89984"; #a89984
          fg3 = "bdae93"; #bdae93
          fg2 = "d5c4a1"; #d5c4a1
          fg1 = "ebdbb2"; #ebdbb2
          fg0 = "fbf1c7"; #fbf1c7
          darkOrange = "fe8019"; #fe8019
        };
        mode = "dark";
      };
    };
    cognates = value: {
      activeBorder1 = variants.${value}.palette.blue;
      activeBorder2 = variants.${value}.palette.purple;
      inactiveBorder1 = variants.${value}.palette.gray;
      inactiveBorder2 = variants.${value}.palette.darkGray;
      text = variants.${value}.palette.fg;
      textField = variants.${value}.palette.bg2;
      bg = variants.${value}.palette.bg;
      btnHoverBg = variants.${value}.palette.darkBlue;
      btnHoverFg = variants.${value}.palette.bg;
      activeWorkspace = variants.${value}.palette.darkOrange;
      inactiveWorkspace = variants.${value}.palette.gray;
      failure = variants.${value}.palette.red;
      warning = variants.${value}.palette.yellow;
      blue = variants.${value}.palette.blue;
      red = variants.${value}.palette.red;
      purple = variants.${value}.palette.purple;
      pink = variants.${value}.palette.aqua;
      yellow = variants.${value}.palette.yellow;
      green = variants.${value}.palette.green;
      bgAlt = variants.${value}.palette.bg;
      textAlt = variants.${value}.palette.fg;
      accentPrimary = variants.${value}.palette.bg;
      accentSecondary = variants.${value}.palette.darkBlue;
    };
  };
}
