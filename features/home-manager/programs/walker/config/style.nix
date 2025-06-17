config: ''
  $color_text: var(--base0D);
  $color_text_field: var(--base02);
  $color_bg: rgba(var(--base01-r), var(--base01-g), var(--base01-b), 0.8);
  $color_btn_hover_bg: var(--base0D);
  $color_btn_hover_fg: var(--base01);
  $color_border: var(--base03);
  $color_active_workspace: var(--base0E);
  $color_inactive_workspace: var(--base0F);
  $color_border_active: var(--base0B);
  $color_urgent: var(--base08);
  $font-family:
    ${config.hm.theme.fonts.defaultMonospace},
    sans-serif;
  $shadow-inset-header: 1px 2px 2px
      color-mix(in oklab, var(--base02) 80%, black 20%) inset,
    2px 4px 4px
      color-mix(in oklab, var(--base02) 80%, black 20%) inset,
    -1px -1px 0px 1px
      color-mix(in oklab, var(--base02) 80%, white 10%) inset,
    -1px -1px 1px 0px
      color-mix(in oklab, var(--base02) 80%, black 5%) inset;

  @mixin input-field {
    all: unset;
    background: $color_text_field;
    border-radius: ${config.hm.hyprland.buttonRounding};
    color: $color_text;
    padding-left: 12px;
    padding-right: 12px;
  }

  * {
    font-family: $font-family;
    font-weight: normal;
    font-size: 15px;
  }

  #window {
    all: unset;
    background: none;
  }
  #box {
    all: unset;
    background: $color_bg;
    padding: 16px;
    border-radius: 10px;
    box-shadow:
      1px 2px 3px rgba(0, 0, 0, 0.17),
      2px 4px 6px rgba(0, 0, 0, 0.20);
  }
  #search {
    all: unset;
    border-radius: 50px;
    padding: 8px 0px 8px 0px;
    background: var(--base02);
    box-shadow: $shadow-inset-header;
    margin: 0px 4px 0px 4px;
  }

  #password {
    @include input-field;
  }
  #input {
    @include input-field;
    background: none;
    > * {
      &:first-child {
        color: $color_text;
        margin-right: 7px;
      }
      &:last-child {
        color: $color_text;
      }
    }
    placeholder {
      opacity: 0.5;
    }
  }
  #typeahead {
    @include input-field;
    opacity: 0.5;
    background: none;
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
    color: $color_btn_hover_bg;
  }

  gridview#list {
    all: unset;
    child.activatable {
      margin: 0px 5px 0px 5px;
      border-radius: ${config.hm.hyprland.buttonRounding};
      color: var(--base0D);
      padding: 8px;
      transition-duration: 0.2s;
      transition-timing-function: linear;
      &:first-child {
        margin-top: 4px;
      }
      &:selected {
        background: var(--window-bg-color);
        box-shadow: var(--shadow-inset-window-bg);
        & * {
          font-weight: bold;
          color: var(--base0D);
        }
      }
    }
  }

  #icon {
    -gtk-icon-size: 40px;
    -gtk-icon-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.20);
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

  #sub {
    all: unset;
    opacity: 0.6;
  }
  #activationlabel {
    all: unset;
    opacity: 0.6;
    padding-right: 4px;
  }
''
