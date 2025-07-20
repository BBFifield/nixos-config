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
    transition-duration: 0.1s;
    transition-timing-function: linear;
    transition-property:
      background-color,
      opacity,
      transform,
      box-shadow,
      -gtk-icon-transform;
  }

  #start,
  #center,
  #end {
    background-color: @base02;
    min-height: 33px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }

  #topbar {
    background-color: transparent;
  }

  #bar {
    margin: 5px 15px 11px 15px;
    padding: 1px 0px 0px 1px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base01, white, 0.1);
  }
  .background {
    padding: 0px;
  }
  window {
    border-radius: 50px;
    background-color: transparent;
    opacity: 0.9;
  }
  /* -- Necessary so menu shadows look okay -- */
  decoration {
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3),
      -1px -1px 0px mix(@base01, white, 0.1);
  }
  box {
    border-radius: 50px;
    background-color: @base01;
  }
  menu {
    background-color: @base01;
    border-radius: 10px;
  }
  menuitem {
    border-radius: 50px;
    min-height: 24px;
    padding: 4px 17px 5px 16px;
    margin: 1px 0px 0px 1px;
  }
  menuitem:hover {
    background-color: @base0D;
  }
  menuitem:hover label,
  menuitem:hover cellview {
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
  widget > revealer > box {
    background-color: transparent;
  }
  button {
    background-color: transparent;
    color: @base0D;
    border-radius: 50px;
    margin: 1px 0px 0px 1px;
    padding: 4px 17px 5px 16px;
    min-height: 24px;
    transition-property:
      opacity,
      transform,
      -gtk-icon-transform;
  }
  button:hover {
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0D, white, 0.4);
  }
  button:hover:active,
  button.focused:not(:hover),
  button:focus {
    background-color: @base02;
    margin: 0px;
    padding: 5px 17px 5px 17px;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  button:hover label {
    color: @base01;
  }
  button:hover:active label,
  button:focus label {
    color: @base0D;
  }
  button box {
    transition: none;
  }
  button:hover box {
    background-color: transparent;
    color: @base01;
  }
  label {
    color: @base0D;
  }

  scale {
    min-height: 10px;
    min-width: 10px;
    padding: 12px 12px 12px 12px;
  }
  scale.marks-after {
    padding: 12px 12px 0px 12px;
  }
  scale trough {
    background-color: @base02;
    border-radius: 99px;
    box-shadow:
      1px 1px 1px mix(@base02, black, 0.2) inset,
      2px 2px 2px mix(@base02, black, 0.2) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  scale highlight {
    border-radius: 99px;
    background-color: @base0B;
  }
  scale slider {
    background-color: @base02;
    border-radius: 100%;
    min-height: 20px;
    min-width: 20px;
    margin: -8px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  scale slider:hover {
    background-color: @base0D;
  }
  scale value {
    color: @base0D;
  }
  scale.vertical trough {
    min-width: 4px;
    min-height: 100px;
  }
  scale.horizontal trough {
    min-height: 100px;
    min-height: 4px;
  }

  tooltip decoration {
    box-shadow: none;
  }
  tooltip {
    background-color: transparent;
    border: 0px;
    text-shadow: none;
    box-shadow: none;
  }
  tooltip > *:last-child {
    border: 0px solid @base0D;
    background-color: @base02;
    margin: 15px 65px 80px 65px;
    min-height: 35px;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  .popup {
    border: 0px solid @base0D;
    border-radius: 10px;
    margin: 15px 65px 80px 65px;
    padding: 15px 15px 10px 15px;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3),
      -1px -1px 0px mix(@base01, white, 0.1);
  }

  /* -- walker button -- */
  #walker box {
    background-color: transparent;
  }
  #walker-img {
    background-color: transparent;
    -gtk-icon-shadow: 0px 0px 2px rgb(0, 0, 0);
    padding: 0px 2px 0px 2px;
  }
  #walker button:hover #walker-img {
    -gtk-icon-transform: rotate(90deg);
  }

  #walker button:hover {
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  #walker button:hover:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }

  /* -- workspaces -- */
  .workspaces {
    background-color: transparent;
  }
  .workspaces label {
    font-size: 17px;
    color: @base0F;
  }
  .workspaces button {
    border-left: 1.3px dotted;
    border-radius: 0px 0px 0px 0px;
    border-color: transparent transparent transparent @base04;
    transition-property:
      background-color,
      opacity,
      transform,
      box-shadow,
      -gtk-icon-transform;
  }
  .workspaces button:last-child {
    border-radius: 0px 50px 50px 0px;
  }
  .workspaces button:hover,
  .workspaces button.focused,
  .workspaces button.focused:hover {
    border-radius: 50px;
    border-color: transparent;
  }
  .workspaces button:hover:not(:active) {
    background-color: @base0F;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0F, white, 0.4);
  }
  .workspaces button.focused:not(:hover),
  .workspaces button:hover:active {
    border-color: transparent;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }

  .workspaces button:hover > label {
    color: @base01;
  }
  .workspaces button:hover:active > label,
  .workspaces .item.focus > label {
    color: @base0F;
  }
  .workspaces button:hover + button,
  .workspaces button.focused + button {
    border-left-color: transparent;
  }

  /* -- clock -- */
  .clock {
    font-weight: bold;
  }
  .popup-clock .calendar-clock {
    color: @base0D;
    font-size: 2.5em;
    margin-bottom: 0.1em;
    border-bottom: 1px solid @base02;
  }
  .popup-clock .calendar {
    background-color: @base01;
    color: @base0D;
    border-color: transparent;
  }
  .popup-clock .calendar .header {
    padding-top: 1em;
    border: transparent;
    font-size: 17px;
  }
  .popup-clock .calendar:selected {
    background-color: @base0D;
    color: @base01;
    border-radius: 50px;
  }

  /* notifications */
  .notifications button.text-button > label {
    font-size: 17px;
  }
  .notifications .count {
    font-size: 0.8rem;
    background-color: @base0D;
    color: @base01;
    border-radius: 100%;
    margin-right: 3px;
    margin-top: 3px;
    padding-left: 4px;
    padding-right: 4px;
    opacity: 0.8;
  }
  overlay.notifications > button.text-button {
    box-shadow: none;
  }
  overlay.notifications > button:hover {
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0D, white, 0.4);
  }
  overlay.notifications > button:hover label {
    color: @base01;
  }
  overlay.notifications > button:hover:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  overlay.notifications > button:active label {
    color: @base0D;
  }

  /*-- tools --*/
  #tools {
    background-color: transparent;
  }
  #tools button {
    background-color: transparent;
  }
  #tools button:hover {
    background-color: @base06;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base06, white, 0.4);
  }
  #tools button:hover label {
    color: @base01;
  }
  #tools button:hover:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  #tools button:active label {
    color: @base06;
  }
  #tools label {
    font-size: 17px;
    margin-left: -3px;
    color: @base06;
  }
  #tools button:hover {
    background-color: @base06;
  }
  #popup-tools {
    border-color: @base06;
  }
  .tool {
    padding: 1px 10px 2px 9px;
    margin: 6px 11px 11px 11px;
    background-color: transparent;
  }
  .tool label {
    font-size: 22px;
  }
  .tool:hover {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0D, white, 0.4);
  }
  .tool:hover:active {
    background-color: @base01;
    padding: 2px 10px 2px 10px;
    margin: 5px 11px 11px 10px;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.35) inset,
      2px 4px 4px mix(@base01, black, 0.35) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  #nightLightToggle:hover {
    background-color: @base0A;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0A, white, 0.4);
  }
  #nightLightToggle:hover label {
    color: @base01;
  }
  #nightLightToggle:hover:active {
    background-color: @base01;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.35) inset,
      2px 4px 4px mix(@base01, black, 0.35) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  #nightLightToggle:hover:active label {
    color: @base0A;
  }
  #nightLightToggle label {
    color: @base0A;
  }

  #screenshotter label {
    color: @base08;
    margin-left: -7px;
  }
  #screenshotter:hover {
    background-color: @base08;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base08, white, 0.4);
  }
  #screenshotter:hover label {
    color: @base01;
  }
  #screenshotter:hover:active {
    background-color: @base01;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.35) inset,
      2px 4px 4px mix(@base01, black, 0.35) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  #screenshotter:hover:active label {
    color: @base08;
  }

  #wallpaperToggle label {
    color: @base0C;
    margin-left: -5px;
  }
  #wallpaperToggle:hover {
    background-color: @base0C;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0C, white, 0.4);
  }
  #wallpaperToggle:hover label {
    color: @base01;
  }
  #wallpaperToggle:hover:active {
    background-color: @base01;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.35) inset,
      2px 4px 4px mix(@base01, black, 0.35) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  #wallpaperToggle:hover:active label {
    color: @base0C;
  }
  .wallpaperNav {
    background-color: @base02;
    padding: 1px 10px 2px 9px;
  }
  .wallpaperNav:hover {
    background-color: @base0C;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0C, white, 0.4);
  }
  .wallpaperNav:hover:active {
    padding: 2px 10px 2px 10px;
    margin: 0px;
  }
  .wallpaperNav label {
    color: @base0C;
  }
  .wallpaperNav:hover label {
    color: @base01;
  }
  .wallpaperNav:hover:active label {
    color: @base0C;
  }
  #popup-tools widget > revealer > box.linked {
    background-color: @base02;
    margin: 5px 5px 10px 5px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  #popup-tools widget > revealer > box.linked > widget {
    border: 0px;
  }

  /*-- tray -- */
  .tray * {
    background-color: @base02;
    border-radius: 50px;
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
    border-bottom: 1px solid @base02;
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
    background-color: @base02;
    margin: 10px 30px 11px 30px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  .reveal-btn:hover:active {
    background-color: @base02;
    margin: 9px 30px 11px 29px;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  .info {
    border-radius: 0px;
    border-top: 1px solid @base02;
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
    font-size: 17px;
    color: @base0E;
    margin-right: 2px;
  }
  #network button:hover {
    background-color: @base0E;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0E, white, 0.4);
  }
  #network button:hover label {
    color: @base01;
  }
  #network button:hover:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  #network button:hover:active label {
    color: @base0E;
  }
  #network button:hover label {
    color: @base01;
  }

  /*-- bluetooth --*/
  #bluetooth button:hover {
    background-color: @base0C;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0C, white, 0.4);
  }
  #bluetooth button:hover label {
    color: @base01;
  }
  #bluetooth button:hover:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  #bluetooth button:active label {
    color: @base0C;
  }
  #bluetooth label {
    font-size: 17px;
    background-color: transparent;
    color: @base0C;
  }
  #popup-bluetooth {
    border-color: @base0C;
    padding-bottom: 10px;
  }
  #popup-bluetooth label {
    color: @base0C;
  }
  #popup-bluetooth button {
    background-color: @base02;
    margin: 21px 6px 11px 7px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  #popup-bluetooth button:hover {
    background-color: @base0C;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0C, white, 0.4);
  }
  #popup-bluetooth button:hover:active {
    background-color: @base02;
    margin: 20px 6px 11px 6px;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  #popup-bluetooth button:hover label {
    color: @base01;
  }
  #popup-bluetooth button:hover:active label {
    color: @base0C;
  }

  /* -- clipboard -- */
  .clipboard {
    font-size: 17px;
  }
  .clipboard > label {
    font-size: 17px;
    color: @base09;
  }
  .clipboard:hover {
    background-color: @base09;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base09, white, 0.4);
  }
  .clipboard:hover label {
    color: @base01;
  }
  .clipbooard:hover:active {
    background-color: @base02;
    margin: 0px;
    padding: 5px 17px 5px 17px;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  .clipboard:hover:active label {
    color: @base09;
  }

  .popup-clipboard {
    border-color: @base09;
    color: @base09;
  }
  .popup-clipboard label {
    color: @base09;
  }
  .popup-clipboard button {
    background-color: @base02;
    margin: 10px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  .popup-clipboard button:hover {
    background-color: @base09;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base09, white, 0.4);
  }
  .popup-clipboard button:hover:active {
    background-color: @base02;
    margin: 9px 10px 10px 9px;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  .popup-clipboard button:hover:active label {
    color: @base09;
  }
  .popup-clipboard .item {
    padding-bottom: 0.3em;
    border-bottom: 1px solid @base02;
    border-radius: 0%;
  }
  radio {
    border: 1px solid @base02;
    background-color: @base02;
    margin: 7px 14px 7px 7px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  radio:checked {
    background-color: @base09;
    border-color: @base09;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base09, white, 0.4);
  }
  .btn-remove {
    margin: 10px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }

  /* -- Volume -- */
  .volume > label {
    font-size: 17px;
    color: @base0A;
    margin-right: 5px;
  }
  .volume:hover {
    background-color: @base0A;
  }
  .volume:hover {
    background-color: @base0A;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0A, white, 0.4);
  }
  .volume:hover label {
    color: @base01;
  }
  .volume:hover:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  .volume:hover:active label {
    color: @base0A;
  }

  .popup-volume {
    border-color: @base0A;
    padding: 20px;
  }
  .popup-volume label,
  .popup-volume .slider .top {
    color: @base0A;
  }
  .popup-volume .device-box {
    border-right: 1px solid @base02;
    border-radius: 0px;
    padding-right: 5px;
  }
  .popup-volume combobox.device-selector > box {
    margin-bottom: 10px;
  }
  .popup-volume button.combo {
    padding: 5px 17px 5px 17px;
    margin: 0;
    box-shadow: none;
  }
  .popup-volume .device-box .device-selector .combo:hover {
    background-color: @base0A;
    padding: 4px 17px 5px 16px;
    margin: 1px 0px 0px 1px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0A, white, 0.4);
  }
  .popup-volume .device-box .device-selector .combo box {
    background-color: @base02;
  }
  .popup-volume .device-box .device-selector .combo:hover box {
    background-color: @base0A;
    color: @base01;
  }
  .popup-volume cellview {
    color: @base0A;
  }
  .popup-volume .combo:hover cellview {
    color: @base01;
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
  .popup-volume button {
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }
  .popup-volume button:hover {
    background-color: @base0A;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0A, white, 0.4);
  }
  .popup-volume button:hover:active,
  .popup-volume button:hover:checked {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  .popup-volume button:hover label {
    color: @base01;
  }
  .popup-volume button:hover:active label {
    color: @base0A;
  }

  #gtk-combobox-popup-menu {
    background-color: @base01;
    color: @base0A;
  }
  #gtk-combobox-popup-menu menuitem:hover {
    background-color: @base0A;
    min-height: 24px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base0A, white, 0.4);
  }
  .btn-mute {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }

  /* -- power -- */
  #power button:hover label {
    color: @base01;
  }
  #power button:hover {
    background-color: @base08;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base08, white, 0.4);
  }
  #power button:hover label {
    color: @base01;
  }
  #power button:hover:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  #power button:active label {
    color: @base08;
  }
  #power label {
    font-size: 17px;
    background-color: transparent;
    color: @base08;
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
    border-radius: 100%;
    min-height: 120px;
    min-width: 120px;
    padding: 0px;
    background-size: contain;
    margin: 10px 10px 17px 10px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
    background-image: url("/var/lib/AccountsService/icons/brandon.face.icon");
  }

  .power-btn {
    border-radius: 100%;
    background-color: transparent;
  }
  #power-actions-box button:hover label {
    color: @base01;
  }
  #power-actions-box button:hover:active label {
    color: @base08;
  }
  #power-actions-box > widget:not(:last-child) .power-btn {
    margin-right: 8px;
  }
  .power-btn:hover {
    background-color: @base08;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base08, white, 0.4);
  }
  #power-actions-box {
    background-color: @base02;
    margin: 9px 9px 12px 9px;
    min-height: 35px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px mix(@base02, white, 0.1);
  }

  /* prettier-ignore */
  #colorPicker { border-color: transparent; }
''
