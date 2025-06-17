config: ''
  @import url("colors.css");

  @keyframes generic-slide-down {
    from {
      margin-top: -140px;
    }
    to {
      margin-top: 0px;
    }
  }

  /* -- base styles -- */
  * {
    font-family:
      ${config.hm.theme.fonts.defaultMonospace},
      sans-serif;
    font-weight: normal;
    font-size: 16px;
    transition-duration: 0.2s;
    transition-timing-function: linear;
    transition-property: background-color, color, opacity, transform, box-shadow, -gtk-icon-transform;
  }

  #start,
  #center,
  #end {
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17), 2px 4px 4px rgba(0, 0, 0, 0.20);
  }
  #topbar {
    background-color: transparent;
  }

  #bar {
    border: 1px solid @base00;
    margin: 5px 15px 11px 15px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17), 2px 4px 4px rgba(0, 0, 0, 0.20);
  }
  .background {
    padding: 0px;
  }
  window {
    border-radius: ${config.hm.hyprland.buttonRounding};
    background-color: transparent;
    opacity: 0.9;
  }
  /* -- Necessary so menu shadows look okay -- */
  decoration {
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0),
      7px 18px 14px rgba(0, 0, 0, 0),
      10px 24px 18px rgba(0, 0, 0, 0),
      14px 30px 24px rgba(0, 0, 0, 0);
  }
  box {
    border-radius: ${config.hm.hyprland.buttonRounding};
    background-color: @base01;
  }
  menu {
    background-color: @base01;
    border: ${toString config.wayland.windowManager.hyprland.settings.general.border_size}px solid @base0D;
    border-radius: ${toString config.wayland.windowManager.hyprland.settings.decoration.rounding}px;
  }
  menuitem {
    border-radius: ${config.hm.hyprland.buttonRounding};
  }
  menuitem:hover {
    background-color: @base0D;
  }
  menuitem:hover label, menuitem:hover cellview {
    font-weight: bold;
    color: @base01;
  }
  separator {
    background-color: transparent;
    border: dotted @base0D;
    margin-right: 15px;
    margin-left: 15px;
    border-width: 1px 0px 0px 0px;
  }
  menubar {
    background-color: @base01;
  }
  button {
    background-color: @base02;
    color: @base0D;
    border-radius: ${config.hm.hyprland.buttonRounding};
    padding: 0px 10px 0px 10px;
  }
  button:hover {
    background-color: @base0D;
  }
  button:hover label {
    color: @base01;
    font-weight: bold;
  }
  button:hover box {
    background-color: @base0D;
    color: @base01;
  }
  label {
    color: @base0D;
  }
  scale trough {
    min-width: 1px;
    min-height: 2px;
  }
  tooltip {
    background-color: transparent;
    border: 0px;
    text-shadow: none;
  }
  tooltip > *:last-child {
    border: ${toString config.wayland.windowManager.hyprland.settings.general.border_size}px solid @base0D;
    background-color: @base02;
    margin: 0px 15px 20px 15px;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.30);
  }
  .popup {
    border: ${toString config.wayland.windowManager.hyprland.settings.general.border_size}px solid @base0D;
    border-radius: ${toString config.wayland.windowManager.hyprland.settings.decoration.rounding}px;
    margin: 15px 65px 80px 65px;
    padding: 15px 15px 10px 15px;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.30);
    }

  /* -- walker button -- */
  #walker box {
    background-color: @base02;
  }
  #walker button:hover {
    background-color: @base02;
  }
  #walker button:hover box {
    background-color: @base02;
  }
  #walker-img {
    -gtk-icon-shadow: 0px 0px 2px rgb(0, 0, 0);
    padding: 0px 2px 0px 2px;
  }
  #walker button:hover #walker-img {
    -gtk-icon-transform: rotate(90deg);
  }

  /* -- workspaces -- */
  .workspaces {
    background-color: @base02;
  }
  .workspaces label {
    color: @base0F;
  }
  .workspaces button {
    border: 1.3px dotted;
    border-radius: 0px 0px 0px 0px;
    border-color: transparent transparent transparent @base04;
  }
  .workspaces button:last-child {
    border-radius: 0px ${config.hm.hyprland.buttonRounding} ${config.hm.hyprland.buttonRounding} 0px;
  }
  .workspaces button:hover {
    background-color: @base03;
    border-radius: ${config.hm.hyprland.buttonRounding};
    border-color: transparent;
  }
  .workspaces button:hover + button {
    background-color: @base02;
    border-radius: ${config.hm.hyprland.buttonRounding};
    border-color: transparent;
  }
  .workspaces button:hover > label {
    color: @base0F;
  }
  .workspaces .item.focused {
    background-color: @base0F;
    border-radius: ${config.hm.hyprland.buttonRounding};
    border: 1px solid @base0F;
    padding: 0px 30px 0px 30px;
  }
  .workspaces .item.focused + button {
    border-left-color: transparent;
  }
  .workspaces .item.focused > label {
    color: @base01;
    font-weight: bold;
  }

  /* -- clock -- */
  .clock {
    font-weight: bold;
  }
  .popup-clock .calendar-clock {
    color: @base0D;
    font-size: 2.5em;
    margin-bottom: 0.1em;
    border-bottom: 1px dotted currentColor;
  }
  .popup-clock .calendar {
    background-color: @base01;
    color: @base0D;
    border-color: transparent;
  }
  .popup-clock .calendar .header {
    padding-top: 1em;
    border: transparent;
    font-size: 1.5em;
  }
  .popup-clock .calendar:selected {
    background-color: @base0D;
    color: @base01;
    border-radius: ${config.hm.hyprland.buttonRounding};
  }

  /* notifications */
  .notifications .count {
    font-size: 0.6rem;
    background-color: @base0D;
    color: @base01;
    border-radius: 100%;
    margin-right: 3px;
    margin-top: 3px;
    padding-left: 4px;
    padding-right: 4px;
    opacity: 0.7;
  }


  /*-- tools --*/
  #tools label {
    margin-left: -3px;
    color: @base06;
  }
  #tools button:hover label {
    color: @base01;
  }
  #tools button:hover {
    background-color: @base06;
  }
  #popup-tools {
    border-color: @base06;
  }
  #popup-tools box widget:not(:first-child) button,
  #popup-tools box widget:not(:first-child) scale {
    margin-top: 5px;
  }
  .tool {
    margin: 6px 11px 11px 11px;
    background-color: transparent;
  }
  .tool label {
    font-size: 25px;
  }
  .tool:hover {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.20);
  }
  #nightLightToggle:hover {
    background-color: @base0A;
  }
  #nightLightToggle:hover label {
    color: @base01;
  }
  #nightLightToggle label {
    color: @base0A;
  }
  #nightLightSlider slider,
  #nightLightSlider .top {
    color: @base0A;
    background-color: @base0A;
  }
  #screenshotter:hover {
    background-color: @base08;
  }
  #screenshotter:hover label {
    color: @base01;
  }
  #screenshotter label {
    color: @base08;
    margin-left: -7px;
  }
  #wallpaperToggle label {
    color: @base0C;
    margin-left: -5px;
  }
  #wallpaperToggle:hover label {
    color: @base01;
  }
  #wallpaperToggle:hover {
    background-color: @base0C;
  }
  .wallpaperNav {
    margin: 5px 0px 10px 0px;
  }
  .wallpaperNav:hover {
    background-color: @base0C;
  }
  .wallpaperNav label {
    color: @base0C;
  }
  .wallpaperNav:hover label {
    color: @base01;
  }
  #wallpaperNext {
    border-top-left-radius: 0px;
    border-bottom-left-radius: 0px;
  }
  #wallpaperPrevious {
    border-top-right-radius: 0px;
    border-bottom-right-radius: 0px;
  }

  /*-- tray -- */
  .tray * {
    background-color: @base02;
    border-radius: ${config.hm.hyprland.buttonRounding};
  }
  .tray .item {
    padding: 0px 10px 0px 10px;
    -gtk-icon-shadow: 0px 0px 2px rgb(0, 0, 0);
  }

  /* -- sys_info -- */
  .sysinfo {
    background-color: @base02;
  }
  .header {
    border-radius: 0px;
    border-bottom: 1px dotted currentColor;
    margin-bottom: 5px;
  }
  #cpu-label {
    color: @base08;
  }
  #ram-label {
    color: @base0E;
  }
  #disk-label {
    color: @base0D;
  }
  #gpu-label {
    color: @base0B;
  }
  #uptime-label {
    color: @base0A;
  }

  .reveal-btn {
    margin: 10px 30px 11px 30px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.20);
  }
  .info {
    border-radius: 0px;
    border-top: 1px dotted @base0D;
    padding-top: 5px;
    animation-name: generic-slide-down;
    animation-timing-function: linear;
    animation-duration: 0.2s;
    animation-fill-mode: forwards;
  }
  #distro-label {
    color: @base0A;
  }
  #build-label {
    color: @base0D;
  }
  #kernel-label {
    color: @base08;
  }
  #hostname-label {
    color: @base0B;
  }
  #packages-label {
    color: @base0E;
  }
  #local-ip-label {
    color: @base0C;
  }
  #public-ip-label {
    color: @base06;
  }

  #colors-label {
    color: @base0F;
  }
  #base00 {
    color: @base00;
  }
  #base01 {
    color: @base01;
  }
  #base02 {
    color: @base02;
  }
  #base03 {
    color: @base03;
  }
  #base04 {
    color: @base04;
  }
  #base05 {
    color: @base05;
  }
  #base06 {
    color: @base06;
  }
  #base07 {
    color: @base07;
  }
  #base08 {
    color: @base08;
  }
  #base09 {
    color: @base09;
  }
  #base0A {
    color: @base0A;
  }
  #base0B {
    color: @base0B;
  }
  #base0C {
    color: @base0C;
  }
  #base0D {
    color: @base0D;
  }
  #base0E {
    color: @base0E;
  }
  #base0F {
    color: @base0F;
  }
  #font-label {
    color: @base07;
  }
  .gtk-label {
    color: @base0B;
  }

  /*-- network --*/
  #network label {
    font-size: 18px;
    color: @base0E;
    margin-right: 2px;
  }
  #network button:hover {
    background-color: @base0E;
  }
  #network button:hover label {
    color: @base01;
  }

  /*-- bluetooth --*/
  #bluetooth button:hover {
    background-color: @base0C;
  }
  #bluetooth label {
    font-size: 17px;
    background-color: @base02;
    color: @base0C;
  }
  #bluetooth button:hover label {
    background-color: @base0C;
    color: @base01;
  }
  #popup-bluetooth {
    border-color: @base0C;
    padding-bottom: 10px;
  }
  #popup-bluetooth button {
    background-color: @base02;
  }
  #popup-bluetooth button:hover {
    background-color: @base0C;
  }
  #popup-bluetooth label {
    color: @base0C;
  }
  #popup-bluetooth button:hover label {
    color: @base01;
  }
  #bluetooth-settings-btn {
    margin: 20px 6px 11px 6px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.20);
  }

  /* -- clipboard -- */
  .clipboard {
    font-size: 1.1em;
  }
  .clipboard > label {
    color: @base09;
  }
  .clipboard:hover {
    background-color: @base09;
  }
  .popup-clipboard {
    border-color: @base09;
    color: @base09;
  }
  .popup-clipboard label {
    color: @base09;
  }
  .popup-clipboard button:hover {
    background-color: @base09;
  }
  .popup-clipboard .item {
    padding-bottom: 0.3em;
    border-bottom: 1px dotted currentColor;
    border-radius: 0%;
  }
  radio {
    border: 1px solid @base02;
    background-color: @base02;
    margin: 7px 14px 7px 7px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.20);
  }
  radio:checked {
    -gtk-icon-source: none;
    background-image: none;
    background-color: @base09;
    border-color: @base09;
  }
  .btn-remove {
    margin: 10px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.20);
  }

  /* -- Volume -- */
  .volume > label {
    color: @base0A;
    margin-right: 5px;
  }
  .volume:hover {
    background-color: @base0A;
  }
  .popup-volume {
    border-color: @base0A;
    padding: 20px;
  }
  .popup-volume label,
  .popup-volume .slider .top {
    color: @base0A;
  }
  .popup-volume slider {
    background-color: @base0A;
  }
  .popup-volume highlight {
    background-color: @base0A;
  }
  .popup-volume .device-box {
    border-right: 1px dotted @base0A;
    border-radius: 0px;
    padding-right: 5px;
  }
  .popup-volume .device-box .device-selector .combo:hover {
    background-color: @base0A;
  }
  .popup-volume .device-box .device-selector .combo box {
    background-color: @base02;
  }
  .popup-volume .device-box .device-selector .combo:hover box {
    background-color: @base0A;
    color: @base01;
    font-weight: bold;
  }
  .popup-volume cellview {
    color: @base0A;
  }
  .popup-volume .combo:hover cellview {
    color: @base01;
    font-weight: bold;
  }
  .popup-volume arrow {
    color: @base0A;
  }
  .popup-volume .combo:hover arrow {
    color: @base01;
  }
  .popup-volume .combo {
    margin-bottom: 10px;
  }
  .popup-volume button:hover {
    background-color: @base0A;
  }
  #gtk-combobox-popup-menu {
    border: ${toString config.wayland.windowManager.hyprland.settings.general.border_size}px solid @base0A;
    background-color: @base01;
    color: @base0A;
  }
  #gtk-combobox-popup-menu menuitem:hover {
    background-color: @base0A;
  }
  .btn-mute, .combo {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.20);
  }


  /* -- power -- */
  #power button:hover {
    background-color: @base08;
  }
  #power label {
    color: @base08;
  }
  #power button:hover label {
    color: @base01;
  }
  #popup-power {
    border-color: @base08;
  }
  #popup-power label {
    color: @base08;
  }
  #profile-header {
    font-size: 1.2em;
    padding-bottom: 0.4em;
    margin-bottom: 0.6em;
  }
  #profile-pic-button {
    border: 1px @base08 solid;
    border-radius: 100%;
    min-height: 120px;
    min-width: 120px;
    padding: 0px;
    background-size: contain;
    margin: 10px 10px 17px 10px;
    box-shadow:
      1px 2px 4px rgba(0, 0, 0, 0.17),
      2px 4px 7px rgba(0, 0, 0, 0.20);
    background-image: url("/var/lib/AccountsService/icons/${config.home.username}.face.icon");
  }
  .power-btn {
    padding: 0.1em 1em;
    border-radius: 100%;
  }
  #power-actions-box button:hover label {
    color: @base01;
  }
  .power-btn:hover {
    background-color: @base08;
  }
  #power-actions-box {
    background-color: @base02;
    margin: 9px 9px 12px 9px;
    box-shadow:
      1px 2px 3px rgba(0, 0, 0, 0.17),
      2px 4px 6px rgba(0, 0, 0, 0.20);
  }

  /* Miscellaneous */
  .inset:active {
    box-shadow:
      0px 2px 3px 1px rgba(0, 0, 0, 0.5),
      0px 5px 3px 5px rgba(0, 0, 0, 0.5) inset;
  }
  .inset-no-shadow:active {
    box-shadow:
      0px 2px 3px 1px rgba(0, 0, 0, 0.5),
      0px 5px 3px 5px rgba(0, 0, 0, 0.5) inset;
  }

  /* prettier-ignore */
  #colorPicker { border-color: transparent; }
''
