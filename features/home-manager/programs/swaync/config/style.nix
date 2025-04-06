config: ''
  @import url("colors.css");

  * {
    font-family:
      ${config.hm.theme.fonts.defaultMonospace},
      sans-serif;
    font-weight: normal;
    font-size: 16px;
    transition-duration: 0.2s;
    transition-timing-function: linear;
    transition-property:
      background-color,
      opacity,
      transform,
      box-shadow,
      -gtk-icon-transform;
  }

  .notification-row:focus,
  .notification-row:hover {
    background: @base0D;
  }

  .notification-row .notification-background .close-button {
    background: @base02;
    color: @base0D;
    margin: 10px 8px 5px 5px;
    box-shadow:
      0 0 0 1px rgba(0, 0, 0, 0.3),
      0 1px 3px 1px rgba(0, 0, 0, 0.7),
      0 2px 6px 2px rgba(0, 0, 0, 0.3);
  }
  .notification-row .notification-background .close-button:hover {
    background: @base0D;
    color: @base01;
    box-shadow:
      0 0 0 1px rgba(0, 0, 0, 0.3),
      0 1px 3px 1px rgba(0, 0, 0, 0.7),
      0 2px 6px 2px rgba(0, 0, 0, 0.3);
  }

  .notification-row .notification-background .notification {
    border-radius: ${config.hm.hyprland.buttonRounding};
    border-width: 0px;
    margin: 10px;
    box-shadow:
      0 0 0 1px rgba(0, 0, 0, 0.3),
      0 1px 3px 1px rgba(0, 0, 0, 0.7),
      0 2px 6px 2px rgba(0, 0, 0, 0.3);
  }

  /*.notification-row .notification-background .notification .notification-action,*/
  /*.notification-row*/
  /*  .notification-background*/
  /*  .notification*/
  /*  .notification-default-action {*/
  /*  background: @base02;*/
  /*  color: @base0D;*/
  /*}*/

  .notification-row
    .notification-background
    .notification
    .notification-action:hover,
  .notification-row
    .notification-background
    .notification
    .notification-default-action:hover {
    color: @base01;
    background: @base0D;
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action {
    /* The large action that also displays the notification summary and body */
    border-radius: ${config.hm.hyprland.buttonRounding};
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action
    .notification-content {
    border-radius: ${config.hm.hyprland.buttonRounding};
    margin: 5px 5px 5px 15px;
    padding: 0px;
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action
    .notification-content
    .text-box
    .summary {
    /* Notification summary/title */
    font-size: 16px;
    font-weight: bold;
    background: transparent;
    color: @base0D;
    text-shadow: none;
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action
    .notification-content
    .text-box
    .time {
    /* Notification time-ago */
    color: @base0D;
    margin-right: 40px;
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action
    .notification-content
    .text-box
    .body {
    /* Notification body */
    font-size: 15px;
    font-weight: normal;
    background: transparent;
    color: @base0D;
    text-shadow: none;
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action:hover
    .notification-content
    .text-box
    .summary {
    /* Notification summary/title */
    color: @base01;
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action:hover
    .notification-content
    .text-box
    .time {
    /* Notification time-ago */
    color: @base01;
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action:hover
    .notification-content
    .text-box
    .body {
    /* Notification body */
    color: @base01;
    font-weight: bold;
  }

  .control-center {
    /* The Control Center which contains the old notifications + widgets */
    background: @base01;
    color: @base0D;
    margin: 10px;
    border-radius: ${toString config.wayland.windowManager.hyprland.settings.decoration.rounding}px;
    border: ${toString config.wayland.windowManager.hyprland.settings.general.border_size}px solid @base0D;
    box-shadow:
      0 0 0 1px rgba(0, 0, 0, 0.3),
      0 1px 3px 1px rgba(0, 0, 0, 0.7),
      0 2px 6px 2px rgba(0, 0, 0, 0.3);
  }

  .control-center
    .control-center-list
    .notification
    .notification-default-action:hover,
  .control-center .control-center-list .notification .notification-action:hover {
    background-color: @base0D;
  }

  .widget-title {
    color: @base0D;
  }
  .widget-title > label {
    font-size: 20px;
  }

  .widget-title > button {
    border-radius: ${config.hm.hyprland.buttonRounding};
    border-width: 0px;
    color: @base0D;
    box-shadow:
      0 0 0 1px rgba(0, 0, 0, 0.3),
      0 1px 3px 1px rgba(0, 0, 0, 0.7),
      0 2px 6px 2px rgba(0, 0, 0, 0.3);
  }
  .widget-title > button:hover {
    background: @base0D;
    color: @base01;
    font-weight: bold;
  }

  /* DND widget */
  .widget-dnd {
    color: @base0D;
    margin: 8px;
    font-weight: bold;
  }

  .widget-dnd > switch {
    border-radius: ${config.hm.hyprland.buttonRounding};
    background: @base02;
    border-width: 0px;
    box-shadow:
      0 0 0 1px rgba(0, 0, 0, 0.3),
      0 1px 3px 1px rgba(0, 0, 0, 0.7),
      0 2px 6px 2px rgba(0, 0, 0, 0.3);
  }

  .widget-dnd > switch:checked {
    background: @base0D;
  }

  .widget-dnd > switch slider {
    background: @base00;
    border-radius: 100%;
  }

  .text-button:hover label {
    font-weight: bold;
  }
''
