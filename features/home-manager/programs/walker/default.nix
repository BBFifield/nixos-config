{
  config,
  pkgs,
  lib,
  ...
}: let
  sassFile = import ./config/style.nix config;
  compiledSassFile =
    pkgs.runCommand "style_walker" {nativeBuildInputs = with pkgs; [dart-sass jq];}
    ''
      #!/usr/bin/env bash
      mkdir -p $out
      cat > "$out/styleWalker.scss" <<'EOF'
      ${sassFile}
      EOF
      sass "$out/styleWalker.scss" "$out/.config/walker/themes/style.css"
      CSS_FILE="$out/.config/walker/themes/style.css"

      { echo "@import url('file://${config.home.homeDirectory}/.config/walker/themes/colors.css');"; cat "$CSS_FILE"; } > temp_file && mv temp_file "$CSS_FILE"
    '';
in {
  options.hm.walker = {
    enable = lib.mkEnableOption "Enable Walker launcher.";
    width = lib.mkOption {
      type = lib.types.int;
      default = 600;
    };
    height = lib.mkOption {
      type = lib.types.int;
      default = 600;
    };
  };

  config = lib.mkIf config.hm.walker.enable (
    lib.mkMerge [
      {
        programs.walker = {
          enable = true;
          runAsService = false;
          config = {
            app_launch_prefix = "uwsm app -- ";
            terminal = "alacritty";
            hotreload_theme = true;
            theme = "style";
            as_window = true;
            close_when_open = true;
            disable_click_to_close = false;
            ignore_mouse = true;
            builtins.websearch = {
              # Some reason the second param doesn't get used by walker even if it's in the config
              entries = let
                customEngines = (import ../browsers/search-engines.nix {inherit pkgs;}).custom;
                entriesList =
                  lib.mapAttrsToList (name': value: {
                    name = lib.toSentenceCase name';
                    url = let
                      urlParts = lib.head value.urls;
                      template = urlParts.template;
                      params = urlParts.params;
                      paramsString = lib.foldl (acc: paramParts: let
                        param = let
                          index = lib.lists.findFirstIndex (x: x.name == paramParts.name && x.value == paramParts.value) null params;
                          nextPrefix =
                            if (index == ((lib.length params) - 1))
                            then ""
                            else "&";
                          value =
                            if paramParts.value == "{searchTerms}"
                            then "%TERM%"
                            else paramParts.value;
                        in
                          paramParts.name + "=" + value + nextPrefix;
                      in
                        acc + param) "?"
                      params;
                    in
                      template + paramsString;
                    prefix = lib.head value.definedAliases;
                    # image = value.icon;
                  })
                  customEngines;
              in
                entriesList;
            };
            builtins.switcher.prefix = "/";
            custom_commands = {
              "name" = "commands";
              "prefix" = "!";
            };
            plugins = [
              {
                "name" = "power";
                "placeholder" = "Power";
                "show_icon_when_single" = true;
                "entries" = [
                  {
                    "label" = "Shutdown";
                    "icon" = "system-shutdown";
                    "exec" = "shutdown now";
                  }
                  {
                    "label" = "Reboot";
                    "icon" = "system-reboot";
                    "exec" = "reboot";
                  }
                  {
                    "label" = "Lock Screen";
                    "icon" = "system-lock-screen";
                    "exec" = "playerctl --all-players pause & pidof hyprlock || hyprlock";
                  }
                ];
              }
              {
                "name" = "color scheme";
                "placeholder" = "Color Scheme";
                "prefix" = "$";
                "switcher_only" = true;
                "recalculate_score" = false;
                "show_icon_when_single" = true;
                "entries" = let
                  entries =
                    lib.mapAttrsToList (schemeName: schemeValue: {
                      "label" = "${schemeName}";
                      "exec" = "tintednix update ${schemeName} ${schemeValue.variant}";
                    })
                    config.hm.tintednix.schemeVariantAndColors;
                in
                  entries;
              }
              {
                name = "wallpapers";
                prefix = "#";
                src_once = "node ${./config/fetch_wallpapers.cjs}";
                parser = "kv";
                recalculate_score = false;
                refresh = true;
                show_icon_when_single = true;
                switcher_only = true;
              }
            ];
          };
        };
      }
      {
        home.packages = [compiledSassFile];
        xdg.configFile."walker/themes/style.css" = {
          source = "${compiledSassFile}/.config/walker/themes/style.css";
          onChange = ''
            (
              log_file="${config.home.homeDirectory}/walker-reload.log"
              echo "Checking for walker..." >> $log_file
              XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
              if [[ -S "$XDG_RUNTIME_DIR/walker-dmenu.sock" ]]; then
                echo "ipc file exists" >> $log_file 2>&1
                ${config.programs.walker.package}/bin/walker --theme style
              else
                echo "ipc file doesn't exist" >> $log_file
              fi
            )
          '';
        };
        xdg.configFile."walker/themes/style.toml".text = import ./config/layout.nix config;
      }
    ]
  );
}
