config: ''
  $buttonRounding: ${toString config.hm.hyprland.buttonRounding};
  $windowRounding: ${toString config.wayland.windowManager.hyprland.settings.decoration.rounding}px;
  $font-family:
    ${config.hm.theme.fonts.defaultMonospace},
    sans-serif;

  @mixin pill(
    $bg: var(--base02),
    $padding: 0 9px,
    $margin: 0 2px 5px 2px
  ) {
    border-radius: $buttonRounding;
    min-height: 35px;
    background: $bg;
    padding: $padding;
    margin: $margin;
  }

  * {
    caret-color: var(--base0D);
    font-family: $font-family;
    font-weight: normal;
    font-size: 15px;
  }

  #window {
    background-color: transparent;
    border-radius: $windowRounding;
    box-shadow: var(--shadow-wide-base01);
  }

  box#box {
    background: rgba(var(--base01-r), var(--base01-g), var(--base01-b), 0.8);
    padding: 16px;
    border-radius: $windowRounding;
  }

  #search {
    @include pill();
    box-shadow: var(--shadow-inset-base02);

    &:backdrop {
      box-shadow: var(--shadow-thin-base02);
    }
  }

  #typeahead {
    @include pill(transparent, 0, 0);
    box-shadow: none;
  }

  #input {
    @include pill(transparent, 0, 0);
    box-shadow: none;
  }

  #spinner {
    color: var(--base0D);
    padding: 0;
  }

  #icon {
    -gtk-icon-size: 40px;
    -gtk-icon-shadow: var(--shadow-thin-base01);
  }

  gridview#list {
    child.activatable {
      margin: 0 2px;
      border-radius: $buttonRounding;
      color: var(--base0D);
      padding: 8px;
      transition: 0.2s linear;

      &:selected {
        background: var(--base01);
        box-shadow: var(--shadow-inset-base01);

        * {
          font-weight: bold;
          color: var(--base0D);
        }
      }
    }
  }

  #sub,
  #activationlabel {
    all: unset;
    opacity: 0.6;
  }

  #activationlabel {
    padding-right: 4px;
  }

  scrollbar {
    color: var(--base0D);
    padding: 0;
    margin: 0;

    > range {
      padding: 0;
      margin: 0;

      > trough {
        border-radius: $buttonRounding;

        > slider {
          background-clip: padding-box;
          border-radius: $buttonRounding;
          border: 8px solid transparent;
          margin: -8px;
          min-width: 8px;
          min-height: 8px;
          transition: all 200ms linear;
          background-color: color-mix(in srgb, currentColor 50%, transparent);

          &:disabled {
            opacity: 0;
          }
        }
      }
    }

    &.bottom.horizontal > range > trough {
      margin: 4px 9px;
    }

    &.right.vertical > range > trough {
      margin: 9px 4px;
    }

    &.overlay-indicator {
      &.horizontal:not(.hovering) > range > trough > slider {
        min-width: 40px;
        min-height: 3px;
      }

      &.vertical:not(.hovering) > range > trough > slider {
        min-width: 3px;
        min-height: 40px;
      }

      &.hovering > range > trough {
        background-color: color-mix(in srgb, currentColor 10%, transparent);
      }

      &.horizontal.hovering > range > trough > slider {
        min-height: 8px;
      }

      &.vertical.hovering > range > trough > slider {
        min-height: 40px;
      }
    }
  }
''
