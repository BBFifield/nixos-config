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

  window {
    opacity: 0.9;
  }

  .notification-row:focus,
  .notification-row:hover {
    background: @base0D;
  }

  .notification-group-header {
    color: @base0D;
    margin-left: 20px;
    font-weight: bold;
  }

  .notification-group-buttons {
    margin-top: 10px;
    margin-bottom: 10px;
  }

  .notification-group-collapse-button {
    color: @base0B;
    margin-right: 5px;
  }

  .notification-group-close-all-button {
    color: @base08;
  }

  .notification-group-collapse-button:hover {
    background: @base0B;
  }

  .notification-group-close-all-button:hover {
    background: @base08;
  }

  button {
    background: @base02;
    border-radius: ${config.hm.hyprland.buttonRounding};
    border-width: 0px;
    color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2);
  }
  button:hover {
    background: @base0D;
    color: @base01;
    font-weight: bold;
  }

  .close-button {
    color: @base08;
    margin: 10px 30px 5px 5px;
  }

  .close-button:hover {
    color: @base01;
    background-color: @base08;
  }

  .control-center .close-button {
    margin: 0px 0px 10px 10px;
  }

  .notification-content image {
    margin-right: 10px;
  }

  .notification {
    background: @base02;
    border-radius: ${config.hm.hyprland.buttonRounding};
    border-width: 0px;
    margin: 10px 30px 60px 20px;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3);
  }

  .control-center .notification {
    margin: 0px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2);
    }

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
    background: @base02;
    border-radius: ${config.hm.hyprland.buttonRounding};
  }

  .notification-row
    .notification-background
    .notification
    .notification-default-action
    .notification-content {
    border-radius: ${config.hm.hyprland.buttonRounding};
    margin: 5px 5px 5px 20px;
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
    color: @base0A;
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
    margin: 20px;
    border-radius: ${toString config.wayland.windowManager.hyprland.settings.decoration.rounding}px;
    border: ${toString config.wayland.windowManager.hyprland.settings.general.border_size}px solid @base0D;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3);
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
    background: @base02;
    border-radius: ${config.hm.hyprland.buttonRounding};
    border-width: 0px;
    color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2);
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
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2);
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

  scrollbar slider {
    background-color: @base0D;
  }

  scrollbar trough {
    background-color: @base01;
  }
''
