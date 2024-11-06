# This was taken from github/Aylur/dotfiles.
{
  config,
  pkgs,
  lib,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};

  lang = icon: color: {
    symbol = icon;
    format = ''[[ $symbol( $version) ](fg:${color} bg:color_fg_field)](bg:color_fg_field)'';
  };
  attrset = import ../../../lookAndFeel/colorschemeInfo.nix;

  mkColorPrefix = name: value: {
    name = "color_${name}";
    value = ''#${value}'';
  };

  mkCognateSet = name: variant: let
    cognates = attrset.${name}.cognates variant;
  in
    lib.listToAttrs (lib.map (cognateName: mkColorPrefix cognateName cognates.${cognateName}) (lib.attrNames cognates));

  mkThemeFile = theme: variant: path: {
    xdg.configFile."${path}/${theme}_${variant}.toml" = {
      source =
        tomlFormat.generate "theme"
        (settings theme variant);
    };
  };

  defaultThemeName = config.hm.theme.colorscheme.name;
  defaultVariantName = config.hm.theme.colorscheme.variant;

  settings = theme: variant: let
    props = attrset.${theme}.props;
  in {
    "$schema" = ''https://starship.rs/config-schema.json'';
    format = lib.concatStrings [
      "[${props.separator_left}](color_btn_hover_bg)"
      "$nix_shell"
      "$os"
      "$username"
      "[${props.separator_right}](bg:color_fg_field fg:color_btn_hover_bg)"
      "$directory"
      "$git_branch"
      "$git_status"
      "$c"
      "$rust"
      "$nodejs"
      "$lua"
      "$java"
      "$haskell"
      "$python"
      "[${props.separator_mid}](fg:color_separator_mid bg:color_fg_field)"
      "$docker_context"
      "$conda"
      "$time"
      "[${props.separator_right} ](color_fg_field)"
      "$cmd_duration"
      "$status"
      "$line_break$character"
    ];

    palette = "${theme}_${variant}";

    palettes."${theme}_${variant}" = mkCognateSet theme variant;

    os = {
      disabled = false;
      style = "bg:color_btn_hover_bg fg:bold color_btn_hover_fg";
    };
    os.symbols = {
      NixOS = "";
      Windows = "󰍲";
      Ubuntu = "󰕈";
      SUSE = "";
      Raspbian = "󰐿";
      Mint = "󰣭";
      Macos = "󰀵";
      Linux = "󰌽";
      Gentoo = "󰣨";
      Fedora = "󰣛";
      Amazon = "";
      Android = "";
      Arch = "󰣇";
      Debian = "󰣚";
      Redhat = "󱄛";
      RedHatEnterprise = "󱄛";
      Pop = "";
    };

    username = {
      show_always = true;
      style_user = "bg:color_btn_hover_bg fg:bold color_btn_hover_fg";
      style_root = "bg:color_btn_hover_bg fg:bold color_btn_hover_fg";
      format = ''[ $user ]($style)'';
    };

    directory = {
      style = "fg:color_fg bg:color_fg_field";
      format = "[[ $path ]($style)${props.separator_mid}](fg:color_separator_mid bg:color_fg_field)";
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    git_branch = {
      symbol = "";
      style = "fg:color_color_slot1 bg:color_fg_field";
      format = ''[ $symbol $branch ]($style)'';
    };

    git_status = {
      style = "fg:color_color_slot1 bg:color_fg_field";
      format = ''[[($all_status$ahead_behind )]($style)${props.separator_mid}](fg:color_separator_mid bg:color_fg_field)'';
    };

    continuation_prompt = "∙  ┆ ";
    line_break = {disabled = false;};
    status = {
      symbol = "✗";
      not_found_symbol = "󰍉 Not Found";
      not_executable_symbol = " Can't Execute E";
      sigint_symbol = "󰂭 ";
      signal_symbol = "󱑽 ";
      success_symbol = "";
      format = "[$symbol](fg:color_failure)";
      map_symbol = true;
      disabled = false;
    };
    cmd_duration = {
      min_time = 1000;
      format = "[$duration ](fg:color_yellow)";
    };
    /*
      nix_shell = {
      disabled = false;
      format = "[${pad.left}](fg:white)[ ](bg:white fg:black)[${pad.right}](fg:white) ";
    };
    */
    container = {
      symbol = " 󰏖";
      format = "[$symbol ](color_yellow)";
    };

    directory.substitutions = {
      "Documents" = "󰈙 ";
      "Downloads" = " ";
      "Music" = "󰝚 ";
      "Pictures" = " ";
      "Developer" = "󰲋 ";
    };

    python = lang "" "color_yellow";
    nodejs = lang "󰛦" "color_blue";
    bun = lang "󰛦" "color_blue";
    deno = lang "󰛦" "color_blue";
    lua = lang "󰢱" "color_blue";
    rust = lang "" "color_red";
    java = lang "" "color_red";
    c = lang "" "color_blue";
    golang = lang "" "color_blue";
    dart = lang "" "color_blue";
    elixir = lang "" "color_purple";

    /*
      conda = {
      style = "bg:color_bg3";
      format = ''[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)'';
    };
    */

    time = {
      disabled = false;
      time_format = "%R";
      style = "bg:color_fg_field";
      format = ''[[  $time ](fg:color_fg $style)]($style)'';
    };

    character = {
      disabled = false;
      success_symbol = "[${props.mascot}](bold fg:color_green)";
      error_symbol = "[${props.mascot}](bold fg:color_failure)";
      vimcmd_symbol = "[${props.mascot}](bold fg:color_green)";
      vimcmd_replace_one_symbol = "[${props.mascot}](bold fg:color_purple)";
      vimcmd_replace_symbol = "[${props.mascot}](bold fg:color_purple)";
      vimcmd_visual_symbol = "[${props.mascot}](bold fg:color_yellow)";
    };
  };
in {
  options.hm.starship = {
    enable = lib.mkEnableOption "Enable starship prompt, your gateway to beautiful command prompts.";
    hot-reload = lib.mkOption {
      type = (import ../../../submodules {inherit lib;}).hot-reload;
    };
  };
  config = lib.mkIf (config.hm.starship.enable) (
    lib.mkMerge [
      {
        programs.starship = {
          enable = true;
          enableBashIntegration = true;
          settings = settings defaultThemeName defaultVariantName;
        };
      }
      (lib.mkIf (config.hm.starship.hot-reload.enable) (
        let
          themeNames = lib.attrNames attrset;
          getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

          themeFilesList = lib.concatMap (theme: lib.map (variant: mkThemeFile theme variant "starship_themes") (getVariantNames theme)) themeNames;

          themeFiles = lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} themeFilesList;
        in
          lib.mkMerge [
            themeFiles
            {
              hm.theme.hot-reload.scriptParts = lib.mkOrder 30 ''
                cp -rf "$directory/starship_themes/$1.toml" "$directory/starship.toml"
              '';
            }
          ]
      ))
    ]
  );
}
