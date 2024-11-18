{config, ...}: {
  style = ''
    @use "walker_colors";

    $color_1: #c6d0f5;
    $color_2: #7f849c;
    $color_3: #89b4fa;
    $color_4: #cad3f5;

    $color_text: walker_colors.$fg;
    $color_text_field: walker_colors.$menu;
    $color_bg: walker_colors.$bg;
    $color_btn_hover_bg: walker_colors.$btn_hover_bg;
    $color_btn_hover_fg: walker_colors.$btn_hover_fg;
    $color_border: walker_colors.$inactive_accent2;
    $color_active_workspace: walker_colors.$active_accent1;
    $color_inactive_workspace: walker_colors.$active_accent2;
    $color_border_active: walker_colors.$color0;
    $color_urgent: walker_colors.$color1;
    $font-family:
      ${config.hm.theme.fonts.defaultMonospace} Nerd Font,
      sans-serif;

    @mixin input-field {
      all: unset;
      background: $color_text_field;
      background: none;
      box-shadow: none;
      border-radius: 0px;
      border-radius: 32px;
      color: $color_text;
      padding-left: 12px;
      padding-right: 12px;
      background: none;
    }

    * {
      font-family: $font-family;
      font-weight: normal;
      font-size: 16px;
    }

    #window {
      all: unset;
      background: none;
    }
    #box {
      all: unset;
      background: $color_bg;
      padding: 16px;
      border-radius: 8px;
      box-shadow:
        0 19px 38px rgba(0, 0, 0, 0.3),
        0 15px 12px rgba(0, 0, 0, 0.22);
    }
    #search {
      all: unset;
    }
    #password {
      @include input-field;
    }
    #input {
      @include input-field;
      > * {
        &:first-child {
          color: $color_btn_hover_fg;
          margin-right: 7px;
        }
        &:last-child {
          color: $color_btn_hover_fg;
        }
      }
      placeholder {
        opacity: 0.5;
      }
    }
    #typeahead {
      @include input-field;
      > * {
        &:first-child {
          color: $color_text;
          margin-right: 7px;
        }
        &:last-child {
          color: $color_text;
        }
      }
    }
    #spinner {
      all: unset;
    }
    #list {
      all: unset;
    }
    child {
      all: unset;
      border-radius: 8px;
      color: $color_btn_hover_fg;
      padding: 4px;
      &:selected {
        background: $color_btn_hover_bg;
        box-shadow: none;
        color: $color_btn_hover_fg;
        #label {
          color: $color_btn_hover_fg;
        }
      }
      &:hover {
        background: $color_btn_hover_bg;
        box-shadow: none;
        color: $color_btn_hover_fg;
        #label {
          color: $color_btn_hover_fg;
        }
      }
    }
    scrollbar {
      all: unset;
      background: none;
      padding-left: 8px;
    }
    slider {
      all: unset;
      min-width: 2px;
      background: $color_text;
      opacity: 0.5;
    }
    #item {
      all: unset;
    }
    #text {
      all: unset;
    }
    #label {
      all: unset;
      font-weight: bold;
      color: $color_text;
    }
    #sub {
      all: unset;
      opacity: 0.5;
      color: $color_text;
    }
    #activationlabel {
      all: unset;
      opacity: 0.5;
      padding-right: 4px;
    }
  '';
}
