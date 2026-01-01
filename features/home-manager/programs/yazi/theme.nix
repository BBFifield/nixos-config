{}: {
  theme = {
    mgr = {
      cwd = {fg = "green";};
      hovered = {
        fg = "black";
        bg = "blue";
      };
      preview_hovered = {
        fg = "black";
        bg = "gray";
      };

      find_keyword = {
        fg = "yellow";
        italic = true;
      };
      find_position = {
        fg = "red";
        bg = "reset";
        italic = true;
      };

      marker_copied = {
        fg = "green";
        bg = "green";
      };
      marker_cut = {
        fg = "red";
        bg = "red";
      };
      marker_marked = {
        fg = "green";
        bg = "red";
      };
      marker_selected = {
        fg = "blue";
        bg = "blue";
      };

      tab_width = 1;

      count_copied = {
        fg = "black";
        bg = "green";
      };
      count_cut = {
        fg = "black";
        bg = "red";
      };
      count_selected = {
        fg = "black";
        bg = "blue";
      };

      border_symbol = "│";
      border_style = {fg = "blue";};
    };

    tabs = {
      active = {
        bg = "cyan";
        fg = "black";
      };

      inactive = {
        bg = "reset";
        fg = "cyan";
      };
      sep_outer = {
        open = "";
        close = "";
      };
    };

    mode = {
      normal_main = {
        fg = "black";
        bg = "blue";
        bold = true;
      };
      normal_alt = {
        fg = "blue";
        bg = "darkgray";
      };

      select_main = {
        fg = "black";
        bg = "green";
        bold = true;
      };
      select_alt = {
        fg = "green";
        bg = "darkgray";
      };

      unset_main = {
        fg = "black";
        bg = "red";
        bold = true;
      };
      unset_alt = {
        fg = "red";
        bg = "darkgray";
      };
    };

    status = {
      separator_open = "";
      separator_close = "";

      progress_label = {
        fg = "reset";
        bold = true;
      };
      progress_normal = {
        fg = "blue";
        bg = "darkgray";
      };
      progress_error = {
        fg = "red";
        bg = "darkgray";
      };

      perm_type = {fg = "blue";};
      perm_read = {fg = "yellow";};
      perm_write = {fg = "red";};
      perm_exec = {fg = "green";};
      perm_sep = {fg = "gray";};
    };

    input = {
      border = {fg = "blue";};
      title = {};
      value = {};
      selected = {reversed = true;};
    };

    pick = {
      border = {fg = "blue";};
      active = {fg = "red";};
      inactive = {};
    };

    confirm = {
      border = {fg = "blue";};
      title = {fg = "blue";};
      content = {};
      list = {};
      btn_yes = {reversed = true;};
      btn_no = {};
    };

    completion = {border = {fg = "blue";};};

    tasks = {
      border = {fg = "blue";};
      title = {};
      hovered = {underline = true;};
    };

    which = {
      mask = {bg = "darkgray";};
      cand = {fg = "green";};
      rest = {fg = "gray";};
      desc = {fg = "red";};
      separator = "  ";
      separator_style = {fg = "darkgray";};
    };

    help = {
      on = {fg = "green";};
      run = {fg = "red";};
      desc = {fg = "gray";};
      hovered = {
        bg = "darkgray";
        bold = true;
      };
      footer = {
        fg = "gray";
        bg = "darkgray";
      };
    };

    notify = {
      title_info = {fg = "green";};
      title_warn = {fg = "yellow";};
      title_error = {fg = "red";};
    };

    filetype = {
      rules = [
        {
          mime = "image/*";
          fg = "green";
        }
        {
          mime = "{audio,video}/*";
          fg = "yellow";
        }

        {
          mime = "application/*zip";
          fg = "red";
        }
        {
          mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
          fg = "red";
        }

        {
          mime = "application/{pdf,doc,rtf}";
          fg = "green";
        }

        {
          name = "*";
          fg = "gray";
        }
        {
          name = "*/";
          fg = "blue";
        }
      ];
    };

    icon = {
      files = [
        {
          name = "kritadisplayrc";
          text = "";
          fg = "magenta";
        }
        {
          name = ".gtkrc-2.0";
          text = "";
          fg = "yellow";
        }
        {
          name = "bspwmrc";
          text = "";
          fg = "darkgray";
        }
        {
          name = "webpack";
          text = "󰜫";
          fg = "cyan";
        }
        {
          name = "tsconfig.json";
          text = "";
          fg = "cyan";
        }
        {
          name = ".vimrc";
          text = "";
          fg = "green";
        }
        {
          name = "gemfile$";
          text = "";
          fg = "darkgray";
        }
        {
          name = "xmobarrc";
          text = "";
          fg = "red";
        }
        {
          name = "avif";
          text = "";
          fg = "gray";
        }
        {
          name = "fp-info-cache";
          text = "";
          fg = "yellow";
        }
        {
          name = ".zshrc";
          text = "";
          fg = "green";
        }
        {
          name = "robots.txt";
          text = "󰚩";
          fg = "darkgray";
        }
        {
          name = "dockerfile";
          text = "󰡨";
          fg = "blue";
        }
        {
          name = ".git-blame-ignore-revs";
          text = "";
          fg = "yellow";
        }
        {
          name = ".nvmrc";
          text = "";
          fg = "green";
        }
        {
          name = "hyprpaper.conf";
          text = "";
          fg = "cyan";
        }
        {
          name = ".prettierignore";
          text = "";
          fg = "blue";
        }
        {
          name = "rakefile";
          text = "";
          fg = "darkgray";
        }
        {
          name = "code_of_conduct";
          text = "";
          fg = "red";
        }
        {
          name = "cmakelists.txt";
          text = "";
          fg = "gray";
        }
        {
          name = ".env";
          text = "";
          fg = "yellow";
        }
        {
          name = "copying.lesser";
          text = "";
          fg = "yellow";
        }
        {
          name = "readme";
          text = "󰂺";
          fg = "yellow";
        }
        {
          name = "settings.gradle";
          text = "";
          fg = "darkgray";
        }
        {
          name = "gruntfile.coffee";
          text = "";
          fg = "yellow";
        }
        {
          name = ".eslintignore";
          text = "";
          fg = "darkgray";
        }
        {
          name = "kalgebrarc";
          text = "";
          fg = "blue";
        }
        {
          name = "kdenliverc";
          text = "";
          fg = "blue";
        }
        {
          name = ".prettierrc.cjs";
          text = "";
          fg = "blue";
        }
        {
          name = "cantorrc";
          text = "";
          fg = "blue";
        }
        {
          name = "rmd";
          text = "";
          fg = "cyan";
        }
        {
          name = "vagrantfile$";
          text = "";
          fg = "darkgray";
        }
        {
          name = ".Xauthority";
          text = "";
          fg = "yellow";
        }
        {
          name = "prettier.config.ts";
          text = "";
          fg = "blue";
        }
        {
          name = "node_modules";
          text = "";
          fg = "red";
        }
        {
          name = ".prettierrc.toml";
          text = "";
          fg = "blue";
        }
        {
          name = "build.zig.zon";
          text = "";
          fg = "yellow";
        }
        {
          name = ".ds_store";
          text = "";
          fg = "darkgray";
        }
        {
          name = "PKGBUILD";
          text = "";
          fg = "blue";
        }
        {
          name = ".prettierrc";
          text = "";
          fg = "blue";
        }
        {
          name = ".bash_profile";
          text = "";
          fg = "green";
        }
        {
          name = ".npmignore";
          text = "";
          fg = "red";
        }
        {
          name = ".mailmap";
          text = "󰊢";
          fg = "yellow";
        }
        {
          name = ".codespellrc";
          text = "󰓆";
          fg = "green";
        }
        {
          name = "svelte.config.js";
          text = "";
          fg = "yellow";
        }
        {
          name = "eslint.config.ts";
          text = "";
          fg = "darkgray";
        }
        {
          name = "config";
          text = "";
          fg = "gray";
        }
        {
          name = ".gitlab-ci.yml";
          text = "";
          fg = "yellow";
        }
        {
          name = ".gitconfig";
          text = "";
          fg = "yellow";
        }
        {
          name = "_gvimrc";
          text = "";
          fg = "green";
        }
        {
          name = ".xinitrc";
          text = "";
          fg = "yellow";
        }
        {
          name = "checkhealth";
          text = "󰓙";
          fg = "blue";
        }
        {
          name = "sxhkdrc";
          text = "";
          fg = "darkgray";
        }
        {
          name = ".bashrc";
          text = "";
          fg = "green";
        }
        {
          name = "tailwind.config.mjs";
          text = "󱏿";
          fg = "cyan";
        }
        {
          name = "ext_typoscript_setup.txt";
          text = "";
          fg = "yellow";
        }
        {
          name = "commitlint.config.ts";
          text = "󰜘";
          fg = "green";
        }
        {
          name = "py.typed";
          text = "";
          fg = "yellow";
        }
        {
          name = ".nanorc";
          text = "";
          fg = "darkgray";
        }
        {
          name = "commit_editmsg";
          text = "";
          fg = "yellow";
        }
        {
          name = ".luaurc";
          text = "";
          fg = "blue";
        }
        {
          name = "fp-lib-table";
          text = "";
          fg = "yellow";
        }
        {
          name = ".editorconfig";
          text = "";
          fg = "yellow";
        }
        {
          name = "justfile";
          text = "";
          fg = "gray";
        }
        {
          name = "kdeglobals";
          text = "";
          fg = "blue";
        }
        {
          name = "license.md";
          text = "";
          fg = "yellow";
        }
        {
          name = ".clang-format";
          text = "";
          fg = "gray";
        }
        {
          name = "docker-compose.yaml";
          text = "󰡨";
          fg = "blue";
        }
        {
          name = "copying";
          text = "";
          fg = "yellow";
        }
        {
          name = "go.mod";
          text = "";
          fg = "cyan";
        }
        {
          name = "lxqt.conf";
          text = "";
          fg = "blue";
        }
        {
          name = "brewfile";
          text = "";
          fg = "darkgray";
        }
        {
          name = "gulpfile.coffee";
          text = "";
          fg = "red";
        }
        {
          name = ".dockerignore";
          text = "󰡨";
          fg = "blue";
        }
        {
          name = ".settings.json";
          text = "";
          fg = "darkgray";
        }
        {
          name = "tailwind.config.js";
          text = "󱏿";
          fg = "cyan";
        }
        {
          name = ".clang-tidy";
          text = "";
          fg = "gray";
        }
        {
          name = ".gvimrc";
          text = "";
          fg = "green";
        }
        {
          name = "nuxt.config.cjs";
          text = "󱄆";
          fg = "green";
        }
        {
          name = "xsettingsd.conf";
          text = "";
          fg = "yellow";
        }
        {
          name = "nuxt.config.js";
          text = "󱄆";
          fg = "green";
        }
        {
          name = "eslint.config.cjs";
          text = "";
          fg = "darkgray";
        }
        {
          name = "sym-lib-table";
          text = "";
          fg = "yellow";
        }
        {
          name = ".condarc";
          text = "";
          fg = "green";
        }
        {
          name = "xmonad.hs";
          text = "";
          fg = "red";
        }
        {
          name = "tmux.conf";
          text = "";
          fg = "green";
        }
        {
          name = "xmobarrc.hs";
          text = "";
          fg = "red";
        }
        {
          name = ".prettierrc.yaml";
          text = "";
          fg = "blue";
        }
        {
          name = ".pre-commit-config.yaml";
          text = "󰛢";
          fg = "yellow";
        }
        {
          name = "i3blocks.conf";
          text = "";
          fg = "yellow";
        }
        {
          name = "xorg.conf";
          text = "";
          fg = "yellow";
        }
        {
          name = ".zshenv";
          text = "";
          fg = "green";
        }
        {
          name = "vlcrc";
          text = "󰕼";
          fg = "yellow";
        }
        {
          name = "license";
          text = "";
          fg = "yellow";
        }
        {
          name = "unlicense";
          text = "";
          fg = "yellow";
        }
        {
          name = "tmux.conf.local";
          text = "";
          fg = "green";
        }
        {
          name = ".SRCINFO";
          text = "󰣇";
          fg = "blue";
        }
        {
          name = "tailwind.config.ts";
          text = "󱏿";
          fg = "cyan";
        }
        {
          name = "security.md";
          text = "󰒃";
          fg = "gray";
        }
        {
          name = "security";
          text = "󰒃";
          fg = "gray";
        }
        {
          name = ".eslintrc";
          text = "";
          fg = "darkgray";
        }
        {
          name = "gradle.properties";
          text = "";
          fg = "darkgray";
        }
        {
          name = "code_of_conduct.md";
          text = "";
          fg = "red";
        }
        {
          name = "PrusaSlicerGcodeViewer.ini";
          text = "";
          fg = "yellow";
        }
        {
          name = "PrusaSlicer.ini";
          text = "";
          fg = "yellow";
        }
        {
          name = "procfile";
          text = "";
          fg = "gray";
        }
        {
          name = "mpv.conf";
          text = "";
          fg = "black";
        }
        {
          name = ".prettierrc.json5";
          text = "";
          fg = "blue";
        }
        {
          name = "i3status.conf";
          text = "";
          fg = "yellow";
        }
        {
          name = "prettier.config.mjs";
          text = "";
          fg = "blue";
        }
        {
          name = ".pylintrc";
          text = "";
          fg = "gray";
        }
        {
          name = "prettier.config.cjs";
          text = "";
          fg = "blue";
        }
        {
          name = ".luacheckrc";
          text = "";
          fg = "blue";
        }
        {
          name = "containerfile";
          text = "󰡨";
          fg = "blue";
        }
        {
          name = "eslint.config.mjs";
          text = "";
          fg = "darkgray";
        }
        {
          name = "gruntfile.js";
          text = "";
          fg = "yellow";
        }
        {
          name = "bun.lockb";
          text = "";
          fg = "yellow";
        }
        {
          name = ".gitattributes";
          text = "";
          fg = "yellow";
        }
        {
          name = "gruntfile.ts";
          text = "";
          fg = "yellow";
        }
        {
          name = "pom.xml";
          text = "";
          fg = "darkgray";
        }
        {
          name = "favicon.ico";
          text = "";
          fg = "yellow";
        }
        {
          name = "package-lock.json";
          text = "";
          fg = "darkgray";
        }
        {
          name = "build";
          text = "";
          fg = "green";
        }
        {
          name = "package.json";
          text = "";
          fg = "red";
        }
        {
          name = "nuxt.config.ts";
          text = "󱄆";
          fg = "green";
        }
        {
          name = "nuxt.config.mjs";
          text = "󱄆";
          fg = "green";
        }
        {
          name = "mix.lock";
          text = "";
          fg = "gray";
        }
        {
          name = "makefile";
          text = "";
          fg = "gray";
        }
        {
          name = "gulpfile.js";
          text = "";
          fg = "red";
        }
        {
          name = "lxde-rc.xml";
          text = "";
          fg = "gray";
        }
        {
          name = "kritarc";
          text = "";
          fg = "magenta";
        }
        {
          name = "gtkrc";
          text = "";
          fg = "yellow";
        }
        {
          name = "ionic.config.json";
          text = "";
          fg = "blue";
        }
        {
          name = ".prettierrc.mjs";
          text = "";
          fg = "blue";
        }
        {
          name = ".prettierrc.yml";
          text = "";
          fg = "blue";
        }
        {
          name = ".npmrc";
          text = "";
          fg = "red";
        }
        {
          name = "weston.ini";
          text = "";
          fg = "yellow";
        }
        {
          name = "gulpfile.babel.js";
          text = "";
          fg = "red";
        }
        {
          name = "i18n.config.ts";
          text = "󰗊";
          fg = "gray";
        }
        {
          name = "commitlint.config.js";
          text = "󰜘";
          fg = "green";
        }
        {
          name = ".gitmodules";
          text = "";
          fg = "yellow";
        }
        {
          name = "gradle-wrapper.properties";
          text = "";
          fg = "darkgray";
        }
        {
          name = "hypridle.conf";
          text = "";
          fg = "cyan";
        }
        {
          name = "vercel.json";
          text = "▲";
          fg = "yellow";
        }
        {
          name = "hyprlock.conf";
          text = "";
          fg = "cyan";
        }
        {
          name = "go.sum";
          text = "";
          fg = "cyan";
        }
        {
          name = "kdenlive-layoutsrc";
          text = "";
          fg = "blue";
        }
        {
          name = "gruntfile.babel.js";
          text = "";
          fg = "yellow";
        }
        {
          name = "compose.yml";
          text = "󰡨";
          fg = "blue";
        }
        {
          name = "i18n.config.js";
          text = "󰗊";
          fg = "gray";
        }
        {
          name = "readme.md";
          text = "󰂺";
          fg = "yellow";
        }
        {
          name = "gradlew";
          text = "";
          fg = "darkgray";
        }
        {
          name = "go.work";
          text = "";
          fg = "cyan";
        }
        {
          name = "gulpfile.ts";
          text = "";
          fg = "red";
        }
        {
          name = "gnumakefile";
          text = "";
          fg = "gray";
        }
        {
          name = "FreeCAD.conf";
          text = "";
          fg = "red";
        }
        {
          name = "compose.yaml";
          text = "󰡨";
          fg = "blue";
        }
        {
          name = "eslint.config.js";
          text = "";
          fg = "darkgray";
        }
        {
          name = "hyprland.conf";
          text = "";
          fg = "cyan";
        }
        {
          name = "docker-compose.yml";
          text = "󰡨";
          fg = "blue";
        }
        {
          name = "groovy";
          text = "";
          fg = "darkgray";
        }
        {
          name = "QtProject.conf";
          text = "";
          fg = "green";
        }
        {
          name = "platformio.ini";
          text = "";
          fg = "yellow";
        }
        {
          name = "build.gradle";
          text = "";
          fg = "darkgray";
        }
        {
          name = ".nuxtrc";
          text = "󱄆";
          fg = "green";
        }
        {
          name = "_vimrc";
          text = "";
          fg = "green";
        }
        {
          name = ".zprofile";
          text = "";
          fg = "green";
        }
        {
          name = ".xsession";
          text = "";
          fg = "yellow";
        }
        {
          name = "prettier.config.js";
          text = "";
          fg = "blue";
        }
        {
          name = ".babelrc";
          text = "";
          fg = "yellow";
        }
        {
          name = "workspace";
          text = "";
          fg = "green";
        }
        {
          name = ".prettierrc.json";
          text = "";
          fg = "blue";
        }
        {
          name = ".prettierrc.js";
          text = "";
          fg = "blue";
        }
        {
          name = ".Xresources";
          text = "";
          fg = "yellow";
        }
        {
          name = ".gitignore";
          text = "";
          fg = "yellow";
        }
        {
          name = ".justfile";
          text = "";
          fg = "gray";
        }
      ];
      exts = [
        {
          name = "otf";
          text = "";
          fg = "yellow";
        }
        {
          name = "import";
          text = "";
          fg = "yellow";
        }
        {
          name = "krz";
          text = "";
          fg = "magenta";
        }
        {
          name = "adb";
          text = "";
          fg = "green";
        }
        {
          name = "ttf";
          text = "";
          fg = "yellow";
        }
        {
          name = "webpack";
          text = "󰜫";
          fg = "cyan";
        }
        {
          name = "dart";
          text = "";
          fg = "darkgray";
        }
        {
          name = "vsh";
          text = "";
          fg = "gray";
        }
        {
          name = "doc";
          text = "󰈬";
          fg = "darkgray";
        }
        {
          name = "zsh";
          text = "";
          fg = "green";
        }
        {
          name = "ex";
          text = "";
          fg = "gray";
        }
        {
          name = "hx";
          text = "";
          fg = "yellow";
        }
        {
          name = "fodt";
          text = "";
          fg = "cyan";
        }
        {
          name = "mojo";
          text = "";
          fg = "yellow";
        }
        {
          name = "templ";
          text = "";
          fg = "yellow";
        }
        {
          name = "nix";
          text = "";
          fg = "blue";
        }
        {
          name = "cshtml";
          text = "󱦗";
          fg = "darkgray";
        }
        {
          name = "fish";
          text = "";
          fg = "darkgray";
        }
        {
          name = "ply";
          text = "󰆧";
          fg = "gray";
        }
        {
          name = "sldprt";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "gemspec";
          text = "";
          fg = "darkgray";
        }
        {
          name = "mjs";
          text = "";
          fg = "yellow";
        }
        {
          name = "csh";
          text = "";
          fg = "darkgray";
        }
        {
          name = "cmake";
          text = "";
          fg = "gray";
        }
        {
          name = "fodp";
          text = "";
          fg = "yellow";
        }
        {
          name = "vi";
          text = "";
          fg = "yellow";
        }
        {
          name = "msf";
          text = "";
          fg = "blue";
        }
        {
          name = "blp";
          text = "󰺾";
          fg = "blue";
        }
        {
          name = "less";
          text = "";
          fg = "darkgray";
        }
        {
          name = "sh";
          text = "";
          fg = "darkgray";
        }
        {
          name = "odg";
          text = "";
          fg = "yellow";
        }
        {
          name = "mint";
          text = "󰌪";
          fg = "green";
        }
        {
          name = "dll";
          text = "";
          fg = "black";
        }
        {
          name = "odf";
          text = "";
          fg = "red";
        }
        {
          name = "sqlite3";
          text = "";
          fg = "yellow";
        }
        {
          name = "Dockerfile";
          text = "󰡨";
          fg = "blue";
        }
        {
          name = "ksh";
          text = "";
          fg = "darkgray";
        }
        {
          name = "rmd";
          text = "";
          fg = "cyan";
        }
        {
          name = "wv";
          text = "";
          fg = "cyan";
        }
        {
          name = "xml";
          text = "󰗀";
          fg = "yellow";
        }
        {
          name = "markdown";
          text = "";
          fg = "gray";
        }
        {
          name = "qml";
          text = "";
          fg = "green";
        }
        {
          name = "3gp";
          text = "";
          fg = "yellow";
        }
        {
          name = "pxi";
          text = "";
          fg = "blue";
        }
        {
          name = "flac";
          text = "";
          fg = "darkgray";
        }
        {
          name = "gpr";
          text = "";
          fg = "magenta";
        }
        {
          name = "huff";
          text = "󰡘";
          fg = "darkgray";
        }
        {
          name = "json";
          text = "";
          fg = "yellow";
        }
        {
          name = "gv";
          text = "󱁉";
          fg = "darkgray";
        }
        {
          name = "bmp";
          text = "";
          fg = "gray";
        }
        {
          name = "lock";
          text = "";
          fg = "gray";
        }
        {
          name = "sha384";
          text = "󰕥";
          fg = "gray";
        }
        {
          name = "cobol";
          text = "⚙";
          fg = "darkgray";
        }
        {
          name = "cob";
          text = "⚙";
          fg = "darkgray";
        }
        {
          name = "java";
          text = "";
          fg = "red";
        }
        {
          name = "cjs";
          text = "";
          fg = "yellow";
        }
        {
          name = "qm";
          text = "";
          fg = "cyan";
        }
        {
          name = "ebuild";
          text = "";
          fg = "darkgray";
        }
        {
          name = "mustache";
          text = "";
          fg = "yellow";
        }
        {
          name = "terminal";
          text = "";
          fg = "green";
        }
        {
          name = "ejs";
          text = "";
          fg = "yellow";
        }
        {
          name = "brep";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "rar";
          text = "";
          fg = "yellow";
        }
        {
          name = "gradle";
          text = "";
          fg = "darkgray";
        }
        {
          name = "gnumakefile";
          text = "";
          fg = "gray";
        }
        {
          name = "applescript";
          text = "";
          fg = "gray";
        }
        {
          name = "elm";
          text = "";
          fg = "cyan";
        }
        {
          name = "ebook";
          text = "";
          fg = "yellow";
        }
        {
          name = "kra";
          text = "";
          fg = "magenta";
        }
        {
          name = "tf";
          text = "";
          fg = "darkgray";
        }
        {
          name = "xls";
          text = "󰈛";
          fg = "darkgray";
        }
        {
          name = "fnl";
          text = "";
          fg = "yellow";
        }
        {
          name = "kdbx";
          text = "";
          fg = "green";
        }
        {
          name = "kicad_pcb";
          text = "";
          fg = "yellow";
        }
        {
          name = "cfg";
          text = "";
          fg = "gray";
        }
        {
          name = "ape";
          text = "";
          fg = "cyan";
        }
        {
          name = "org";
          text = "";
          fg = "green";
        }
        {
          name = "yml";
          text = "";
          fg = "gray";
        }
        {
          name = "swift";
          text = "";
          fg = "yellow";
        }
        {
          name = "eln";
          text = "";
          fg = "gray";
        }
        {
          name = "sol";
          text = "";
          fg = "cyan";
        }
        {
          name = "awk";
          text = "";
          fg = "darkgray";
        }
        {
          name = "7z";
          text = "";
          fg = "yellow";
        }
        {
          name = "apl";
          text = "⍝";
          fg = "yellow";
        }
        {
          name = "epp";
          text = "";
          fg = "yellow";
        }
        {
          name = "app";
          text = "";
          fg = "darkgray";
        }
        {
          name = "dot";
          text = "󱁉";
          fg = "darkgray";
        }
        {
          name = "kpp";
          text = "";
          fg = "magenta";
        }
        {
          name = "eot";
          text = "";
          fg = "yellow";
        }
        {
          name = "hpp";
          text = "";
          fg = "gray";
        }
        {
          name = "spec.tsx";
          text = "";
          fg = "darkgray";
        }
        {
          name = "hurl";
          text = "";
          fg = "red";
        }
        {
          name = "cxxm";
          text = "";
          fg = "cyan";
        }
        {
          name = "c";
          text = "";
          fg = "blue";
        }
        {
          name = "fcmacro";
          text = "";
          fg = "red";
        }
        {
          name = "sass";
          text = "";
          fg = "red";
        }
        {
          name = "yaml";
          text = "";
          fg = "gray";
        }
        {
          name = "xz";
          text = "";
          fg = "yellow";
        }
        {
          name = "material";
          text = "󰔉";
          fg = "red";
        }
        {
          name = "json5";
          text = "";
          fg = "yellow";
        }
        {
          name = "signature";
          text = "λ";
          fg = "yellow";
        }
        {
          name = "3mf";
          text = "󰆧";
          fg = "gray";
        }
        {
          name = "jpg";
          text = "";
          fg = "magenta";
        }
        {
          name = "xpi";
          text = "";
          fg = "yellow";
        }
        {
          name = "fcmat";
          text = "";
          fg = "red";
        }
        {
          name = "pot";
          text = "";
          fg = "cyan";
        }
        {
          name = "bin";
          text = "";
          fg = "darkgray";
        }
        {
          name = "xlsx";
          text = "󰈛";
          fg = "darkgray";
        }
        {
          name = "aac";
          text = "";
          fg = "cyan";
        }
        {
          name = "kicad_sym";
          text = "";
          fg = "yellow";
        }
        {
          name = "xcstrings";
          text = "";
          fg = "cyan";
        }
        {
          name = "lff";
          text = "";
          fg = "yellow";
        }
        {
          name = "xcf";
          text = "";
          fg = "darkgray";
        }
        {
          name = "azcli";
          text = "";
          fg = "darkgray";
        }
        {
          name = "license";
          text = "";
          fg = "yellow";
        }
        {
          name = "jsonc";
          text = "";
          fg = "yellow";
        }
        {
          name = "xaml";
          text = "󰙳";
          fg = "darkgray";
        }
        {
          name = "md5";
          text = "󰕥";
          fg = "gray";
        }
        {
          name = "xm";
          text = "";
          fg = "cyan";
        }
        {
          name = "sln";
          text = "";
          fg = "darkgray";
        }
        {
          name = "jl";
          text = "";
          fg = "gray";
        }
        {
          name = "ml";
          text = "";
          fg = "yellow";
        }
        {
          name = "http";
          text = "";
          fg = "blue";
        }
        {
          name = "x";
          text = "";
          fg = "blue";
        }
        {
          name = "wvc";
          text = "";
          fg = "cyan";
        }
        {
          name = "wrz";
          text = "󰆧";
          fg = "gray";
        }
        {
          name = "csproj";
          text = "󰪮";
          fg = "darkgray";
        }
        {
          name = "wrl";
          text = "󰆧";
          fg = "gray";
        }
        {
          name = "wma";
          text = "";
          fg = "cyan";
        }
        {
          name = "woff2";
          text = "";
          fg = "yellow";
        }
        {
          name = "woff";
          text = "";
          fg = "yellow";
        }
        {
          name = "tscn";
          text = "";
          fg = "gray";
        }
        {
          name = "webmanifest";
          text = "";
          fg = "yellow";
        }
        {
          name = "webm";
          text = "";
          fg = "yellow";
        }
        {
          name = "fcbak";
          text = "";
          fg = "red";
        }
        {
          name = "log";
          text = "󰌱";
          fg = "gray";
        }
        {
          name = "wav";
          text = "";
          fg = "cyan";
        }
        {
          name = "wasm";
          text = "";
          fg = "darkgray";
        }
        {
          name = "styl";
          text = "";
          fg = "green";
        }
        {
          name = "gif";
          text = "";
          fg = "magenta";
        }
        {
          name = "resi";
          text = "";
          fg = "red";
        }
        {
          name = "aiff";
          text = "";
          fg = "cyan";
        }
        {
          name = "sha256";
          text = "󰕥";
          fg = "gray";
        }
        {
          name = "igs";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "vsix";
          text = "";
          fg = "darkgray";
        }
        {
          name = "vim";
          text = "";
          fg = "green";
        }
        {
          name = "diff";
          text = "";
          fg = "darkgray";
        }
        {
          name = "drl";
          text = "";
          fg = "red";
        }
        {
          name = "erl";
          text = "";
          fg = "red";
        }
        {
          name = "vhdl";
          text = "󰍛";
          fg = "green";
        }
        {
          name = "🔥";
          text = "";
          fg = "yellow";
        }
        {
          name = "hrl";
          text = "";
          fg = "red";
        }
        {
          name = "fsi";
          text = "";
          fg = "cyan";
        }
        {
          name = "mm";
          text = "";
          fg = "cyan";
        }
        {
          name = "bz";
          text = "";
          fg = "yellow";
        }
        {
          name = "vh";
          text = "󰍛";
          fg = "green";
        }
        {
          name = "kdb";
          text = "";
          fg = "green";
        }
        {
          name = "gz";
          text = "";
          fg = "yellow";
        }
        {
          name = "cpp";
          text = "";
          fg = "cyan";
        }
        {
          name = "ui";
          text = "";
          fg = "darkgray";
        }
        {
          name = "txt";
          text = "󰈙";
          fg = "green";
        }
        {
          name = "spec.ts";
          text = "";
          fg = "cyan";
        }
        {
          name = "ccm";
          text = "";
          fg = "red";
        }
        {
          name = "typoscript";
          text = "";
          fg = "yellow";
        }
        {
          name = "typ";
          text = "";
          fg = "cyan";
        }
        {
          name = "txz";
          text = "";
          fg = "yellow";
        }
        {
          name = "test.ts";
          text = "";
          fg = "cyan";
        }
        {
          name = "tsx";
          text = "";
          fg = "darkgray";
        }
        {
          name = "mk";
          text = "";
          fg = "gray";
        }
        {
          name = "webp";
          text = "";
          fg = "magenta";
        }
        {
          name = "opus";
          text = "";
          fg = "darkgray";
        }
        {
          name = "bicep";
          text = "";
          fg = "cyan";
        }
        {
          name = "ts";
          text = "";
          fg = "cyan";
        }
        {
          name = "tres";
          text = "";
          fg = "gray";
        }
        {
          name = "torrent";
          text = "";
          fg = "green";
        }
        {
          name = "cxx";
          text = "";
          fg = "cyan";
        }
        {
          name = "iso";
          text = "";
          fg = "red";
        }
        {
          name = "ixx";
          text = "";
          fg = "cyan";
        }
        {
          name = "hxx";
          text = "";
          fg = "gray";
        }
        {
          name = "gql";
          text = "";
          fg = "red";
        }
        {
          name = "tmux";
          text = "";
          fg = "green";
        }
        {
          name = "ini";
          text = "";
          fg = "gray";
        }
        {
          name = "m3u8";
          text = "󰲹";
          fg = "red";
        }
        {
          name = "image";
          text = "";
          fg = "red";
        }
        {
          name = "tfvars";
          text = "";
          fg = "darkgray";
        }
        {
          name = "tex";
          text = "";
          fg = "darkgray";
        }
        {
          name = "cbl";
          text = "⚙";
          fg = "darkgray";
        }
        {
          name = "flc";
          text = "";
          fg = "yellow";
        }
        {
          name = "elc";
          text = "";
          fg = "gray";
        }
        {
          name = "test.tsx";
          text = "";
          fg = "darkgray";
        }
        {
          name = "twig";
          text = "";
          fg = "green";
        }
        {
          name = "sql";
          text = "";
          fg = "yellow";
        }
        {
          name = "test.jsx";
          text = "";
          fg = "cyan";
        }
        {
          name = "htm";
          text = "";
          fg = "yellow";
        }
        {
          name = "gcode";
          text = "󰐫";
          fg = "darkgray";
        }
        {
          name = "test.js";
          text = "";
          fg = "yellow";
        }
        {
          name = "ino";
          text = "";
          fg = "cyan";
        }
        {
          name = "tcl";
          text = "󰛓";
          fg = "darkgray";
        }
        {
          name = "cljs";
          text = "";
          fg = "cyan";
        }
        {
          name = "tsconfig";
          text = "";
          fg = "yellow";
        }
        {
          name = "img";
          text = "";
          fg = "red";
        }
        {
          name = "t";
          text = "";
          fg = "cyan";
        }
        {
          name = "fcstd1";
          text = "";
          fg = "red";
        }
        {
          name = "out";
          text = "";
          fg = "darkgray";
        }
        {
          name = "jsx";
          text = "";
          fg = "cyan";
        }
        {
          name = "bash";
          text = "";
          fg = "green";
        }
        {
          name = "edn";
          text = "";
          fg = "cyan";
        }
        {
          name = "rss";
          text = "";
          fg = "yellow";
        }
        {
          name = "flf";
          text = "";
          fg = "yellow";
        }
        {
          name = "cache";
          text = "";
          fg = "yellow";
        }
        {
          name = "sbt";
          text = "";
          fg = "red";
        }
        {
          name = "cppm";
          text = "";
          fg = "cyan";
        }
        {
          name = "svelte";
          text = "";
          fg = "yellow";
        }
        {
          name = "mo";
          text = "∞";
          fg = "gray";
        }
        {
          name = "sv";
          text = "󰍛";
          fg = "green";
        }
        {
          name = "ko";
          text = "";
          fg = "yellow";
        }
        {
          name = "suo";
          text = "";
          fg = "darkgray";
        }
        {
          name = "sldasm";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "icalendar";
          text = "";
          fg = "darkgray";
        }
        {
          name = "go";
          text = "";
          fg = "cyan";
        }
        {
          name = "sublime";
          text = "";
          fg = "yellow";
        }
        {
          name = "stl";
          text = "󰆧";
          fg = "gray";
        }
        {
          name = "mobi";
          text = "";
          fg = "yellow";
        }
        {
          name = "graphql";
          text = "";
          fg = "red";
        }
        {
          name = "m3u";
          text = "󰲹";
          fg = "red";
        }
        {
          name = "cpy";
          text = "⚙";
          fg = "darkgray";
        }
        {
          name = "kdenlive";
          text = "";
          fg = "blue";
        }
        {
          name = "pyo";
          text = "";
          fg = "yellow";
        }
        {
          name = "po";
          text = "";
          fg = "cyan";
        }
        {
          name = "scala";
          text = "";
          fg = "red";
        }
        {
          name = "exs";
          text = "";
          fg = "gray";
        }
        {
          name = "odp";
          text = "";
          fg = "yellow";
        }
        {
          name = "dump";
          text = "";
          fg = "yellow";
        }
        {
          name = "stp";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "step";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "ste";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "aif";
          text = "";
          fg = "cyan";
        }
        {
          name = "strings";
          text = "";
          fg = "cyan";
        }
        {
          name = "cp";
          text = "";
          fg = "cyan";
        }
        {
          name = "fsscript";
          text = "";
          fg = "cyan";
        }
        {
          name = "mli";
          text = "";
          fg = "yellow";
        }
        {
          name = "bak";
          text = "󰁯";
          fg = "gray";
        }
        {
          name = "ssa";
          text = "󰨖";
          fg = "yellow";
        }
        {
          name = "toml";
          text = "";
          fg = "red";
        }
        {
          name = "makefile";
          text = "";
          fg = "gray";
        }
        {
          name = "php";
          text = "";
          fg = "gray";
        }
        {
          name = "zst";
          text = "";
          fg = "yellow";
        }
        {
          name = "spec.jsx";
          text = "";
          fg = "cyan";
        }
        {
          name = "kbx";
          text = "󰯄";
          fg = "darkgray";
        }
        {
          name = "fbx";
          text = "󰆧";
          fg = "gray";
        }
        {
          name = "blend";
          text = "󰂫";
          fg = "yellow";
        }
        {
          name = "ifc";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "spec.js";
          text = "";
          fg = "yellow";
        }
        {
          name = "so";
          text = "";
          fg = "yellow";
        }
        {
          name = "desktop";
          text = "";
          fg = "darkgray";
        }
        {
          name = "sml";
          text = "λ";
          fg = "yellow";
        }
        {
          name = "slvs";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "pp";
          text = "";
          fg = "yellow";
        }
        {
          name = "ps1";
          text = "󰨊";
          fg = "darkgray";
        }
        {
          name = "dropbox";
          text = "";
          fg = "darkgray";
        }
        {
          name = "kicad_mod";
          text = "";
          fg = "yellow";
        }
        {
          name = "bat";
          text = "";
          fg = "green";
        }
        {
          name = "slim";
          text = "";
          fg = "yellow";
        }
        {
          name = "skp";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "css";
          text = "";
          fg = "blue";
        }
        {
          name = "xul";
          text = "";
          fg = "yellow";
        }
        {
          name = "ige";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "glb";
          text = "";
          fg = "yellow";
        }
        {
          name = "ppt";
          text = "󰈧";
          fg = "red";
        }
        {
          name = "sha512";
          text = "󰕥";
          fg = "gray";
        }
        {
          name = "ics";
          text = "";
          fg = "darkgray";
        }
        {
          name = "mdx";
          text = "";
          fg = "cyan";
        }
        {
          name = "sha1";
          text = "󰕥";
          fg = "gray";
        }
        {
          name = "f3d";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "ass";
          text = "󰨖";
          fg = "yellow";
        }
        {
          name = "godot";
          text = "";
          fg = "gray";
        }
        {
          name = "ifb";
          text = "";
          fg = "darkgray";
        }
        {
          name = "cson";
          text = "";
          fg = "yellow";
        }
        {
          name = "lib";
          text = "";
          fg = "black";
        }
        {
          name = "luac";
          text = "";
          fg = "blue";
        }
        {
          name = "heex";
          text = "";
          fg = "gray";
        }
        {
          name = "scm";
          text = "󰘧";
          fg = "yellow";
        }
        {
          name = "psd1";
          text = "󰨊";
          fg = "gray";
        }
        {
          name = "sc";
          text = "";
          fg = "red";
        }
        {
          name = "scad";
          text = "";
          fg = "yellow";
        }
        {
          name = "kts";
          text = "";
          fg = "darkgray";
        }
        {
          name = "svh";
          text = "󰍛";
          fg = "green";
        }
        {
          name = "mts";
          text = "";
          fg = "cyan";
        }
        {
          name = "nfo";
          text = "";
          fg = "yellow";
        }
        {
          name = "pck";
          text = "";
          fg = "gray";
        }
        {
          name = "rproj";
          text = "󰗆";
          fg = "green";
        }
        {
          name = "rlib";
          text = "";
          fg = "yellow";
        }
        {
          name = "cljd";
          text = "";
          fg = "cyan";
        }
        {
          name = "ods";
          text = "";
          fg = "green";
        }
        {
          name = "res";
          text = "";
          fg = "red";
        }
        {
          name = "apk";
          text = "";
          fg = "green";
        }
        {
          name = "haml";
          text = "";
          fg = "yellow";
        }
        {
          name = "d.ts";
          text = "";
          fg = "yellow";
        }
        {
          name = "razor";
          text = "󱦘";
          fg = "darkgray";
        }
        {
          name = "rake";
          text = "";
          fg = "darkgray";
        }
        {
          name = "patch";
          text = "";
          fg = "darkgray";
        }
        {
          name = "cuh";
          text = "";
          fg = "gray";
        }
        {
          name = "d";
          text = "";
          fg = "red";
        }
        {
          name = "query";
          text = "";
          fg = "green";
        }
        {
          name = "psb";
          text = "";
          fg = "cyan";
        }
        {
          name = "nu";
          text = ">";
          fg = "green";
        }
        {
          name = "mov";
          text = "";
          fg = "yellow";
        }
        {
          name = "lrc";
          text = "󰨖";
          fg = "yellow";
        }
        {
          name = "pyx";
          text = "";
          fg = "blue";
        }
        {
          name = "pyw";
          text = "";
          fg = "blue";
        }
        {
          name = "cu";
          text = "";
          fg = "green";
        }
        {
          name = "bazel";
          text = "";
          fg = "green";
        }
        {
          name = "obj";
          text = "󰆧";
          fg = "gray";
        }
        {
          name = "pyi";
          text = "";
          fg = "yellow";
        }
        {
          name = "pyd";
          text = "";
          fg = "yellow";
        }
        {
          name = "exe";
          text = "";
          fg = "darkgray";
        }
        {
          name = "pyc";
          text = "";
          fg = "yellow";
        }
        {
          name = "fctb";
          text = "";
          fg = "red";
        }
        {
          name = "part";
          text = "";
          fg = "green";
        }
        {
          name = "blade.php";
          text = "";
          fg = "red";
        }
        {
          name = "git";
          text = "";
          fg = "yellow";
        }
        {
          name = "psd";
          text = "";
          fg = "cyan";
        }
        {
          name = "qss";
          text = "";
          fg = "green";
        }
        {
          name = "csv";
          text = "";
          fg = "green";
        }
        {
          name = "psm1";
          text = "󰨊";
          fg = "gray";
        }
        {
          name = "dconf";
          text = "";
          fg = "yellow";
        }
        {
          name = "config.ru";
          text = "";
          fg = "darkgray";
        }
        {
          name = "prisma";
          text = "";
          fg = "darkgray";
        }
        {
          name = "conf";
          text = "";
          fg = "gray";
        }
        {
          name = "clj";
          text = "";
          fg = "green";
        }
        {
          name = "o";
          text = "";
          fg = "darkgray";
        }
        {
          name = "mp4";
          text = "";
          fg = "yellow";
        }
        {
          name = "cc";
          text = "";
          fg = "red";
        }
        {
          name = "kicad_prl";
          text = "";
          fg = "yellow";
        }
        {
          name = "bz3";
          text = "";
          fg = "yellow";
        }
        {
          name = "asc";
          text = "󰦝";
          fg = "darkgray";
        }
        {
          name = "png";
          text = "";
          fg = "magenta";
        }
        {
          name = "android";
          text = "";
          fg = "green";
        }
        {
          name = "pm";
          text = "";
          fg = "cyan";
        }
        {
          name = "h";
          text = "";
          fg = "gray";
        }
        {
          name = "pls";
          text = "󰲹";
          fg = "red";
        }
        {
          name = "ipynb";
          text = "";
          fg = "yellow";
        }
        {
          name = "pl";
          text = "";
          fg = "cyan";
        }
        {
          name = "ads";
          text = "";
          fg = "yellow";
        }
        {
          name = "sqlite";
          text = "";
          fg = "yellow";
        }
        {
          name = "pdf";
          text = "";
          fg = "red";
        }
        {
          name = "pcm";
          text = "";
          fg = "darkgray";
        }
        {
          name = "ico";
          text = "";
          fg = "yellow";
        }
        {
          name = "a";
          text = "";
          fg = "yellow";
        }
        {
          name = "R";
          text = "󰟔";
          fg = "darkgray";
        }
        {
          name = "ogg";
          text = "";
          fg = "darkgray";
        }
        {
          name = "pxd";
          text = "";
          fg = "blue";
        }
        {
          name = "kdenlivetitle";
          text = "";
          fg = "blue";
        }
        {
          name = "jxl";
          text = "";
          fg = "gray";
        }
        {
          name = "nswag";
          text = "";
          fg = "green";
        }
        {
          name = "nim";
          text = "";
          fg = "yellow";
        }
        {
          name = "bqn";
          text = "⎉";
          fg = "darkgray";
        }
        {
          name = "cts";
          text = "";
          fg = "cyan";
        }
        {
          name = "fcparam";
          text = "";
          fg = "red";
        }
        {
          name = "rs";
          text = "";
          fg = "yellow";
        }
        {
          name = "mpp";
          text = "";
          fg = "cyan";
        }
        {
          name = "fdmdownload";
          text = "";
          fg = "green";
        }
        {
          name = "pptx";
          text = "󰈧";
          fg = "red";
        }
        {
          name = "jpeg";
          text = "";
          fg = "gray";
        }
        {
          name = "bib";
          text = "󱉟";
          fg = "yellow";
        }
        {
          name = "vhd";
          text = "󰍛";
          fg = "green";
        }
        {
          name = "m";
          text = "";
          fg = "blue";
        }
        {
          name = "js";
          text = "";
          fg = "yellow";
        }
        {
          name = "eex";
          text = "";
          fg = "gray";
        }
        {
          name = "tbc";
          text = "󰛓";
          fg = "darkgray";
        }
        {
          name = "astro";
          text = "";
          fg = "red";
        }
        {
          name = "sha224";
          text = "󰕥";
          fg = "gray";
        }
        {
          name = "xcplayground";
          text = "";
          fg = "yellow";
        }
        {
          name = "el";
          text = "";
          fg = "gray";
        }
        {
          name = "m4v";
          text = "";
          fg = "yellow";
        }
        {
          name = "m4a";
          text = "";
          fg = "cyan";
        }
        {
          name = "cs";
          text = "󰌛";
          fg = "darkgray";
        }
        {
          name = "hs";
          text = "";
          fg = "gray";
        }
        {
          name = "tgz";
          text = "";
          fg = "yellow";
        }
        {
          name = "fs";
          text = "";
          fg = "cyan";
        }
        {
          name = "luau";
          text = "";
          fg = "blue";
        }
        {
          name = "dxf";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "download";
          text = "";
          fg = "green";
        }
        {
          name = "cast";
          text = "";
          fg = "yellow";
        }
        {
          name = "qrc";
          text = "";
          fg = "green";
        }
        {
          name = "lua";
          text = "";
          fg = "blue";
        }
        {
          name = "lhs";
          text = "";
          fg = "gray";
        }
        {
          name = "md";
          text = "";
          fg = "gray";
        }
        {
          name = "leex";
          text = "";
          fg = "gray";
        }
        {
          name = "ai";
          text = "";
          fg = "yellow";
        }
        {
          name = "lck";
          text = "";
          fg = "gray";
        }
        {
          name = "kt";
          text = "";
          fg = "darkgray";
        }
        {
          name = "bicepparam";
          text = "";
          fg = "gray";
        }
        {
          name = "hex";
          text = "";
          fg = "darkgray";
        }
        {
          name = "zig";
          text = "";
          fg = "yellow";
        }
        {
          name = "bzl";
          text = "";
          fg = "green";
        }
        {
          name = "cljc";
          text = "";
          fg = "green";
        }
        {
          name = "kicad_dru";
          text = "";
          fg = "yellow";
        }
        {
          name = "fctl";
          text = "";
          fg = "red";
        }
        {
          name = "f#";
          text = "";
          fg = "cyan";
        }
        {
          name = "odt";
          text = "";
          fg = "cyan";
        }
        {
          name = "conda";
          text = "";
          fg = "green";
        }
        {
          name = "vala";
          text = "";
          fg = "darkgray";
        }
        {
          name = "erb";
          text = "";
          fg = "darkgray";
        }
        {
          name = "mp3";
          text = "";
          fg = "cyan";
        }
        {
          name = "bz2";
          text = "";
          fg = "yellow";
        }
        {
          name = "coffee";
          text = "";
          fg = "yellow";
        }
        {
          name = "cr";
          text = "";
          fg = "yellow";
        }
        {
          name = "f90";
          text = "󱈚";
          fg = "darkgray";
        }
        {
          name = "jwmrc";
          text = "";
          fg = "darkgray";
        }
        {
          name = "c++";
          text = "";
          fg = "red";
        }
        {
          name = "fcscript";
          text = "";
          fg = "red";
        }
        {
          name = "fods";
          text = "";
          fg = "green";
        }
        {
          name = "cue";
          text = "󰲹";
          fg = "red";
        }
        {
          name = "srt";
          text = "󰨖";
          fg = "yellow";
        }
        {
          name = "info";
          text = "";
          fg = "yellow";
        }
        {
          name = "hh";
          text = "";
          fg = "gray";
        }
        {
          name = "sig";
          text = "λ";
          fg = "yellow";
        }
        {
          name = "html";
          text = "";
          fg = "yellow";
        }
        {
          name = "iges";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "kicad_wks";
          text = "";
          fg = "yellow";
        }
        {
          name = "hbs";
          text = "";
          fg = "yellow";
        }
        {
          name = "fcstd";
          text = "";
          fg = "red";
        }
        {
          name = "gresource";
          text = "";
          fg = "yellow";
        }
        {
          name = "sub";
          text = "󰨖";
          fg = "yellow";
        }
        {
          name = "ical";
          text = "";
          fg = "darkgray";
        }
        {
          name = "crdownload";
          text = "";
          fg = "green";
        }
        {
          name = "pub";
          text = "󰷖";
          fg = "yellow";
        }
        {
          name = "vue";
          text = "";
          fg = "green";
        }
        {
          name = "gd";
          text = "";
          fg = "gray";
        }
        {
          name = "fsx";
          text = "";
          fg = "cyan";
        }
        {
          name = "mkv";
          text = "";
          fg = "yellow";
        }
        {
          name = "py";
          text = "";
          fg = "yellow";
        }
        {
          name = "kicad_sch";
          text = "";
          fg = "yellow";
        }
        {
          name = "epub";
          text = "";
          fg = "yellow";
        }
        {
          name = "env";
          text = "";
          fg = "yellow";
        }
        {
          name = "magnet";
          text = "";
          fg = "darkgray";
        }
        {
          name = "elf";
          text = "";
          fg = "darkgray";
        }
        {
          name = "fodg";
          text = "";
          fg = "yellow";
        }
        {
          name = "svg";
          text = "󰜡";
          fg = "yellow";
        }
        {
          name = "dwg";
          text = "󰻫";
          fg = "green";
        }
        {
          name = "docx";
          text = "󰈬";
          fg = "darkgray";
        }
        {
          name = "pro";
          text = "";
          fg = "yellow";
        }
        {
          name = "db";
          text = "";
          fg = "yellow";
        }
        {
          name = "rb";
          text = "";
          fg = "darkgray";
        }
        {
          name = "r";
          text = "󰟔";
          fg = "darkgray";
        }
        {
          name = "scss";
          text = "";
          fg = "red";
        }
        {
          name = "cow";
          text = "󰆚";
          fg = "yellow";
        }
        {
          name = "gleam";
          text = "";
          fg = "red";
        }
        {
          name = "v";
          text = "󰍛";
          fg = "green";
        }
        {
          name = "kicad_pro";
          text = "";
          fg = "yellow";
        }
        {
          name = "liquid";
          text = "";
          fg = "green";
        }
        {
          name = "zip";
          text = "";
          fg = "yellow";
        }
      ];
    };
  };
}
