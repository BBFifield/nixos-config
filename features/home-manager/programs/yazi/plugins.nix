{pkgs}: {
  git = {
    init = ''
      require("git"):setup({})
    '';
  };
  piper = {
    settings = {
      prepend_previewers = [
        {
          url = "*.csv";
          run = ''piper -- ${pkgs.bat}/bin/bat -p --color=always "$1"'';
        }
        {
          url = "*.md";
          run = ''piper -- CLICOLOR_FORCE=1 ${pkgs.glow}/bin/glow -w=$w -s=dark "$1"'';
        }
        {
          url = "*/";
          run = ''piper -- ${pkgs.eza}/bin/eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
        }
        {
          url = "*";
          run = ''piper -- ${pkgs.hexyl}/bin/hexyl --border=none --terminal-width=$w "$1"'';
        }
      ];
    };
  };
  ouch = {
    prepend_keymap = [
      {
        on = ["C"];
        run = "plugin ouch";
        desc = "Compress with ouch";
      }
    ];
    settings = {
      prepend_previewers = [
        # Archive previewer
        {
          mime = "application/*zip";
          run = "ouch";
        }
        {
          mime = "application/x-tar";
          run = "ouch";
        }
        {
          mime = "application/x-bzip2";
          run = "ouch";
        }
        {
          mime = "application/x-7z-compressed";
          run = "ouch";
        }
        {
          mime = "application/x-rar";
          run = "ouch";
        }
        {
          mime = "application/vnd.rar";
          run = "ouch";
        }
        {
          mime = "application/x-xz";
          run = "ouch";
        }
        {
          mime = "application/xz";
          run = "ouch";
        }
        {
          mime = "application/x-zstd";
          run = "ouch";
        }
        {
          mime = "application/zstd";
          run = "ouch";
        }
        {
          mime = "application/java-archive";
          run = "ouch";
        }
      ];
    };
  };
  mount = {
    prepend_keymap = [
      {
        on = "M";
        run = "plugin mount";
      }
    ];
  };
  mediainfo = {
    prepend_keymap = [
      {
        on = "<F9>";
        run = "plugin mediainfo -- toggle-metadata";
        desc = "Toggle media preview metadata";
      }
    ];
    settings = {
      prepend_preloaders = [
        # Replace magick, image, video with mediainfo
        {
          mime = "{audio,video,image}/*";
          run = "mediainfo";
        }
        {
          mime = "application/subrip";
          run = "mediainfo";
        }
        # Adobe Illustrator, Adobe Photoshop is image/adobe.photoshop, already handled above
        {
          mime = "application/postscript";
          run = "mediainfo";
        }
      ];
      prepend_previewers = [
        # Replace magick, image, video with mediainfo
        {
          mime = "{audio,video,image}/*";
          run = "mediainfo";
        }
        {
          mime = "application/subrip";
          run = "mediainfo";
        }
        # Adobe Illustrator, Adobe Photoshop is image/adobe.photoshop, already handled above
        {
          mime = "application/postscript";
          run = "mediainfo";
        }
        # There are more extensions which are supported by mediainfo.
        # Just add file's MIME type to `previewers`, `preloaders` above.
        # https://mediaarea.net/en/MediaInfo/Support/Formats];
      ];
    };
  };
  recycle-bin = {
    prepend_keymap = [
      {
        on = ["R" "b"];
        run = "plugin recycle-bin";
        desc = "Open Recycle Bin menu";
      }
    ];
  };
  restore = {
    prepend_keymap = [
      {
        on = ["d" "U"];
        run = "plugin restore -- --interactive";
        desc = "Restore deleted files/folders (Interactive)";
      }
    ];

    init = ''
      require("restore"):setup({
        -- Set the position for confirm and overwrite prompts.
        -- Don't forget to set height: `h = xx`
        -- https://yazi-rs.github.io/docs/plugins/utils/#ya.input
        position = { "center", w = 70, h = 40 }, -- Optional

        -- Show confirm prompt before restore.
        -- NOTE: even if set this to false, overwrite prompt still pop up
        show_confirm = true,  -- Optional

        -- Suppress success notification when all files or folder are restored.
        suppress_success_notification = false,  -- Optional

        -- colors for confirm and overwrite prompts
        theme = { -- Optional
          -- Default using style from your flavor or theme.lua -> [confirm] -> title.
          -- If you edit flavor or theme.lua you can add more style than just color.
          -- Example in theme.lua -> [confirm]: title = { fg = "blue", bg = "green"  }
          -- title = "blue", -- Optional. This value has higher priority than flavor/theme.lua

          -- Default using style from your flavor or theme.lua -> [confirm] -> content
          -- Sample logic as title above
          -- header = "green", -- Optional. This value has higher priority than flavor/theme.lua

          -- header color for overwrite prompt
          -- Default using color "yellow"
          -- header_warning = "yellow", -- Optional
          -- Default using style from your flavor or theme.lua -> [confirm] -> list
          -- Sample logic as title and header above
          -- list_item = { odd = "blue", even = "blue" }, -- Optional. This value has higher priority than flavor/theme.lua
        },
      })
    '';
  };
  starship = {
    init = ''
      require("starship"):setup({
        -- Hide flags (such as filter, find and search). This is recommended for starship themes which
        -- are intended to go across the entire width of the terminal.
        hide_flags = false, -- Default: false
        -- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
        flags_after_prompt = true, -- Default: true
        -- Custom starship configuration file to use
        config_file = "~/.config/starship.toml", -- Default: nil
      })
    '';
  };
  full-border = {
    init = ''
      require("full-border"):setup {
        -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
        type = ui.Border.ROUNDED,
      }
    '';
  };
  compress = {
    prepend_keymap = [
      {
        on = ["c" "a" "a"];
        run = "plugin compress";
        desc = "Archive selected files";
      }
      {
        on = ["c" "a" "p"];
        run = "plugin compress -p";
        desc = "Archive selected files (password)";
      }
      {
        on = ["c" "a" "h"];
        run = "plugin compress -ph";
        desc = "Archive selected files (password+header)";
      }
      {
        on = ["c" "a" "l"];
        run = "plugin compress -l";
        desc = "Archive selected files (compression level)";
      }
      {
        on = ["c" "a" "u"];
        run = "plugin compress -phl";
        desc = "Archive selected files (password+header+level)";
      }
    ];
  };
}
