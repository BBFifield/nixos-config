{config, ...}: {
  style = ''
    $color_text: var(--base07);
    $color_text_field: var(--base02);
    $color_bg: var(--base00);
    $color_btn_hover_bg: var(--base07);
    $color_btn_hover_fg: var(--base07);
    $color_border: var(--base03);
    $color_active_workspace: var(--base0E);
    $color_inactive_workspace: var(--base0F);
    $color_border_active: var(--base0B);
    $color_urgent: var(--base08);
    $font-family:
      ${config.hm.theme.fonts.defaultMonospace} Nerd Font,
      sans-serif;

    @mixin input-field {
      all: unset;
      background: $color_text_field;
      border-radius: 0px;
      border-radius: 32px;
      color: $color_text;
      padding-left: 12px;
      padding-right: 12px;
      /* background: none;*/
    }

    * {
      font-family: $font-family;
      font-weight: normal;
      font-size: 14px;
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
      border-radius: 8px;
      padding: 8px 0px 8px 0px;
      background: $color_text_field;
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
      opacity: 0.5;
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

    @mixin highlightLabels {
      background: $color_btn_hover_bg;
      box-shadow: none;
      color: $color_btn_hover_fg;
      label {
        color: $color_bg;
      }
      #sub {
        color: $color_bg;
      }
      #activationlabel {
        color: $color_btn_hover_fg;
      }
    }

    child {
      all: unset;
      border-radius: 8px;
      color: $color_btn_hover_fg;
      padding: 4px;
      &:selected {
        @include highlightLabels;
      }

      &:hover {
        @include highlightLabels;
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
    label {
      all: unset;
      font-weight: normal;
      color: $color_text;
    }
    #sub {
      all: unset;
      opacity: 0.6;
      color: $color_text;
    }
    #activationlabel {
      all: unset;
      opacity: 0.6;
      padding-right: 4px;
      color: $color_text;
    }
  '';
}
