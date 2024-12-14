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
    format = ''[[ $symbol( $version) ](fg:${color} bg:19)](bg:black)'';
  };

  settings =
    #theme: variant:
    let
      props = {
        separator_left = "";
        separator_right = "";
        separator_mid = "";
        char_symbol = "";
      };
    in {
      "$schema" = ''https://starship.rs/config-schema.json'';
      format = lib.concatStrings [
        "$nix_shell"
        "[${props.separator_left}](blue)"
        "$os"
        "$username"
        "[${props.separator_right}](fg:blue bg:19)"
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
        "[${props.separator_mid}](fg:blue bg:19)"
        "$docker_context"
        "$conda"
        "$time"
        "[${props.separator_right} ](19)"
        "$cmd_duration"
        "$status"
        "$line_break$character"
      ];

      os = {
        disabled = false;
        style = "fg:bold 18 bg:blue";
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
        style_user = "fg:bold 18 bg:blue";
        style_root = "fg:bold 18 bg:blue";
        format = ''[ $user ]($style)'';
      };

      directory = {
        style = "fg:blue bg:19";
        format = "[[ $path ]($style)${props.separator_mid}]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "fg:purple bg:19";
        format = ''[ $symbol $branch ]($style)'';
      };

      git_status = {
        style = "fg:purple bg:19";
        format = ''[[($all_status$ahead_behind )]($style)${props.separator_mid}](fg:blue bg:19)'';
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
        format = "[$symbol](fg:red)";
        map_symbol = true;
        disabled = false;
      };
      cmd_duration = {
        min_time = 1000;
        format = "[$duration ](fg:yellow)";
      };

      nix_shell = {
        disabled = false;
        format = "[${props.separator_left}](fg:white)[ ](fg:18 bg:white)[${props.separator_right} ](fg:white) ";
      };

      container = {
        symbol = " 󰏖";
        format = "[$symbol ](yellow)";
      };

      directory.substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = "󰝚 ";
        "Pictures" = " ";
        "Developer" = "󰲋 ";
      };

      python = lang "" "yellow";
      nodejs = lang "󰛦" "blue";
      bun = lang "󰛦" "blue";
      deno = lang "󰛦" "blue";
      lua = lang "󰢱" "blue";
      rust = lang "" "red";
      java = lang "" "red";
      c = lang "" "blue";
      golang = lang "" "blue";
      dart = lang "" "blue";
      elixir = lang "" "purple";

      /*
        conda = {
        style = "bg:color_bg3";
        format = ''[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)'';
      };
      */

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:19";
        format = ''[[  $time ](fg:12 $style)]($style)'';
      };

      character = {
        disabled = false;
        success_symbol = "[${props.char_symbol}](bold fg:green)";
        error_symbol = "[${props.char_symbol}](bold fg:red)";
        vimcmd_symbol = "[${props.char_symbol}](bold fg:green)";
        vimcmd_replace_one_symbol = "[${props.char_symbol}](bold fg:purple)";
        vimcmd_replace_symbol = "[${props.char_symbol}](bold fg:purple)";
        vimcmd_visual_symbol = "[${props.char_symbol}](bold fg:yellow)";
      };
    };
in {
  options.hm.starship = {
    enable = lib.mkEnableOption "Enable starship prompt, your gateway to beautiful command prompts.";
  };
  config = lib.mkIf (config.hm.starship.enable) (
    lib.mkMerge [
      {
        programs.starship = {
          enable = true;
          enableBashIntegration = true;
          settings = settings;
        };
      }
    ]
  );
}
