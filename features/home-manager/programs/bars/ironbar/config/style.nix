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

  @keyframes ripple-in {
    from {
      background-image: radial-gradient(circle farthest-corner at center, alpha(currentColor, 1) 100%, transparent 0%);
    }
    to {
      background-image: radial-gradient(circle farthest-corner at center, alpha(currentColor, 1) 0%, transparent 0%);
    }
  }

  @keyframes ripple-out-base09 {
    from {
      background-image: radial-gradient(circle farthest-corner at center, alpha(@base09, 1) 0%, transparent 0%);
    }
    to {
      background-image: radial-gradient(circle farthest-corner at center, alpha(@base09, 1) 100%, transparent 0%);
    }
  }

  @keyframes ripple-in-base09 {
    from {
      background-image: radial-gradient(circle farthest-corner at center, alpha(@base09, 1) 100%, transparent 0%);
    }
    to {
      background-image: radial-gradient(circle farthest-corner at center, alpha(@base09, 1) 0%, transparent 0%);
    }
  }

  /* -- base styles -- */
  #start,
  #center,
  #end {
    min-height: 33px;
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base02-white-90-dark;
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
      -1px -1px 0px @base01-white-90-dark;
  }
  .background {
    padding: 0px;
  }
  window {
    opacity: 0.9;
    background-color: transparent;
  }

  box {
    border-radius: 50px;
  }
  menu {
    background-color: @base01;
  }
  menuitem,
  menuitem:hover {
    min-height: 24px;
    margin: 1px 0px 0px 1px;
    padding: 4px 17px 5px 16px;
  }
  menuitem:hover {
    background-color: @base0D;
  }
  menuitem:hover label,
  menuitem:hover cellview {
    color: @base01;
  }

  menubar {
    background-color: @base01;
  }
  button box {
    transition: none;
  }
  widget > revealer > box {
    background-color: transparent;
  }
  /**/
  button {
    padding: 1px 17px 2px 16px;
  }
  button:hover {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0D-white-65-dark;
  }
  button:focus,
  button:hover:active,
  button.focused:not(:hover) {
    margin: 0px;
    padding: 2px 17px 2px 17px;
    box-shadow:
      1px 2px 2px @base02-black-80 inset,
      2px 4px 4px @base02-black-80 inset,
      -1px -1px 0px @base02-white-90-dark inset;
  }
  button:hover:checked {
    padding: 2px 17px 2px 17px;
    box-shadow:
      1px 2px 2px @base0D-black-60 inset,
      2px 4px 4px @base0D-black-60 inset,
      -1px -1px 0px @base0D-white-65-dark inset;
  }
  button:hover label,
  button:hover box {
    color: @base01;
    background-color: transparent;
  }
  button label,
  button:focus label,
  button:hover:active label,
  button:hover:checked label {
    color: inherit;
  }

  tooltip > *:last-child {
    background-color: @base02;
  }

  .popup {
    margin: 15px 65px 80px 65px;
    padding: 6px 12px 6px 12px;
    border-radius: 10px;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3),
      -1px -1px 0px @base01-white-90-dark;
  }

  /* -- workspaces -- */
  .workspaces {
    margin: 0px;
    box-shadow: none;
  }
  .workspaces > button {
    padding: 1px 9px 2px 8px;
    color: @base0F;
    transition-property: box-shadow;
  }
  .workspaces > button > label,
  .workspaces > button.item.focused:hover > label,
  .workspaces > button.item:hover:active > label {
    font-size: 17px;
    color: @base0F;
  }
  .workspaces > button:hover:not(:active) > label,
  .workspaces > button.focused + button:hover > label {
    color: @base01;
  }
  .workspaces > button.focused {
    color: @base02;
  }
  .workspaces > button.focused:hover,
  .workspaces > button.focused,
  .workspaces > button:hover:active {
    margin: 0px;
    padding: 2px 9px 2px 9px;
    border-radius: 50px;
    /*shadow-inset-base02*/
    box-shadow:
      1px 2px 2px @base02-black-80 inset,
      2px 4px 4px @base02-black-80 inset,
      -1px -1px 0px @base02-white-90-dark inset;

    animation: ripple-in 200ms cubic-bezier(0, 0, 0.2, 1) forwards;
  }
  .workspaces > button + button:not(.focused):not(:hover):not(:active) {
    margin: 1px 0px 0px 2px;
    padding: 1px 9px 2px 10px;
  }
  .workspaces > button:not(.focused):hover:not(:active) {
    color: @base0F;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0F-white-65-dark;
  }
  .workspaces > button.focused + button:hover:not(:active),
  .workspaces > button + button:not(.focused):hover:not(:active) {
    margin: 1px 0px 0px 4px;
    padding: 1px 9px 2px 8px;
    color: @base0F;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0F-white-65-dark;
  }
  .workspaces > button + button:active,
  .workspaces > button + button.focused,
  .workspaces > button + button:hover:active,
  .workspaces > button + button.focused:hover,
  .workspaces > button + button.focused:hover:active {
    margin: 0px 0px 0px 3px;
  }
  .workspaces button:hover + button:not(.focused),
  .workspaces button.focused + button {
    box-shadow: none;
  }

  /* -- walker button -- */
  #walker button {
  }
  #walker button label {
    margin-right: 5px;
    font-size: 22px;
  }
  #walker box {
    background-color: transparent;
  }

  /* -- clock -- */
  .clock label {
    font-size: 17px;
  }
  .popup-clock .calendar-clock {
    margin-bottom: 1px;
    padding: 0px 29px;

    font-family: "DS-Digital", sans-serif;
    font-size: 50px;
    color: @base08;
    /* shadow-separator-mimic-bottom-horizontal-base01 */
    box-shadow:
      0px -2px 0px @base01-black-65-dark inset,
      0px -1px 0px @base01-black-80-dark inset,
      0px 1px 0px @base01-white-90-dark;
  }
  .popup-clock .calendar {
    border-width: 0px;
    color: @base0D;
    background-color: @base01;
  }
  .popup-clock .calendar:selected {
    color: @base01;
    background-color: @base0D;
  }

  /* notifications */
  .notifications button.text-button > label {
    font-size: 17px;
  }
  .notifications .count {
    margin-top: 3px;
    margin-right: 3px;
    padding-right: 4px;
    padding-left: 4px;
    border-radius: 50%;

    font-size: 0.8rem;
    color: @base01;

    opacity: 0.8;
    background-color: @base0D;
  }
  overlay.notifications > button {
    color: @base0D;
    box-shadow: none;
  }
  overlay.notifications > button:hover {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0D-white-65-dark;
  }
  overlay.notifications > button:hover:active {
    box-shadow:
      1px 2px 2px @base02-black-80 inset,
      2px 4px 4px @base02-black-80 inset,
      -1px -1px 0px @base02-white-90-dark inset;
  }

  /*-- tools --*/
  #tools {
    color: @base06;
  }
  #tools label {
    margin-left: -3px;
    font-size: 17px;
  }
  #tools button {
    color: @base06;
  }
  #tools button:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base06-white-65-dark;
  }
  .tool {
    margin: 6px 11px 11px 11px;
    padding: 1px 10px 2px 9px;
  }
  .tool label {
    font-size: 22px;
  }
  .tool:hover:active {
    margin: 5px 11px 11px 10px;
    padding: 2px 10px 2px 10px;
    box-shadow:
      1px 2px 2px @base01-black-80 inset,
      2px 4px 4px @base01-black-80 inset,
      -1px -1px 0px @base01-white-90-dark inset;
  }

  #nightLightToggle {
    color: @base0A;
  }
  #nightLightToggle:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0A-white-65-dark;
  }

  #screenshotter {
    color: @base08;
  }
  #screenshotter:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base08-white-65-dark;
  }
  #screenshotter label {
    margin-left: -7px;
  }

  #wallpaperToggle {
    color: @base0C;
  }
  #wallpaperToggle:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0C-white-65-dark;
  }
  #wallpaperToggle label {
    margin-left: -5px;
  }
  #wallpaperNavButtons.linked > widget {
    box-shadow: none;
  }
  .wallpaperNav {
    padding: 1px 10px 2px 9px;
    color: @base0C;
  }
  .wallpaperNav:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0C-white-65-dark;
  }
  .wallpaperNav:hover:active {
    margin: 0px;
    padding: 2px 10px 2px 10px;
  }
  .wallpaperNav:hover label {
    color: @base01;
  }
  #popup-tools widget > revealer > box.linked {
    margin: 5px 5px 10px 5px;
    background-color: @base02;
  }
  #popup-tools widget > revealer > box.linked > widget {
    border: 0px;
  }

  /*-- tray -- */
  .tray .item {
    padding: 0px 9px 0px 9px;

    -gtk-icon-shadow: 0px 0px 2px rgb(0, 0, 0);
  }

  /* -- sys_info -- */
  #stats-btn,
  #stats-btn label {
    background-color: transparent;
  }
  #stats-btn:hover label {
    background-color: transparent;
  }
  #stats-btn:active label,
  #stats-btn:hover:active {
    color: @base0D;
    background-color: transparent;
  }
  .header {
    margin-bottom: 5px;
    padding-bottom: 7px;
    /* shadow-separator-mimic-bottom-horizontal-base01 */
    box-shadow:
      0px -2px 0px @base01-black-65-dark inset,
      0px -1px 0px @base01-black-80-dark inset,
      0px 1px 0px @base01-white-90-dark;
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
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base02-white-90-dark;
  }
  .reveal-btn:hover:active {
    margin: 9px 30px 11px 29px;
  }
  .info {
    padding-top: 5px;
    border-top: 1px solid @base02;
    border-radius: 0px;
    animation: generic-slide-down 0.2s cubic-bezier(0, 0, 0.2, 1) forwards;
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
    margin-right: 2px;
    font-size: 17px;
    color: @base0E;
  }
  #network button {
    color: @base0E;
  }
  #network button:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0E-white-65-dark;
  }
  #network button:hover label {
    color: @base01;
  }
  #network button:hover:active label {
    color: @base0E;
  }

  /*-- bluetooth --*/
  #bluetooth button {
    color: @base0C;
  }
  #bluetooth button:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0C-white-65-dark;
  }
  #bluetooth button:hover label {
    color: @base01;
  }
  #bluetooth label,
  #bluetooth button:active label {
    font-size: 17px;
    color: @base0C;
    background-color: transparent;
  }
  #popup-bluetooth {
    padding-bottom: 0px;
  }
  #popup-bluetooth label {
    color: @base0C;
  }
  #popup-bluetooth button {
    margin: 21px 6px 11px 7px;
    color: @base0C;
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base02-white-90-dark;
  }
  #popup-bluetooth button:hover {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0C-white-65-dark;
  }
  #popup-bluetooth button:hover:active {
    margin: 20px 6px 11px 6px;
    background-color: @base02;
    box-shadow:
      1px 2px 2px @base02-black-80 inset,
      2px 4px 4px @base02-black-80 inset,
      -1px -1px 0px @base02-white-90-dark inset;
  }
  #popup-bluetooth button:hover label {
    color: @base01;
  }
  #popup-bluetooth button:hover:active label {
    color: @base0C;
  }

  /* -- clipboard -- */
  .clipboard,
  .clipboard > label,
  .clipboard:hover:active label {
    font-size: 17px;
    color: @base09;
  }
  .clipboard:hover:not(:active),
  .popup-clipboard button:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base09-white-65-dark;
  }

  .popup-clipboard label {
    color: @base09;
  }
  .popup-clipboard button {
    margin: 10px;
    color: @base09;
  }
  .popup-clipboard button:hover:active {
    margin: 9px 10px 10px 9px;
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
    margin-right: 12px;
    animation: ripple-in-base09 200ms cubic-bezier(0, 0, 0.2, 1) forwards;
  }
  radio:checked {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base09-white-65-dark;
    animation: ripple-out-base09 200ms cubic-bezier(0, 0, 0.2, 1) forwards;
  }

  /* -- Volume -- */
  .volume {
    color: @base0A;
  }
  .volume > label {
    margin-right: 5px;
    font-size: 17px;
    color: @base0A;
  }
  .volume:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0A-white-65-dark;
  }
  .volume:hover label {
    color: @base01;
  }
  .volume:hover:active label {
    color: @base0A;
  }

  .popup-volume {
    padding: 20px;
  }
  .popup-volume label,
  .popup-volume .slider .top {
    color: @base0A;
  }
  .popup-volume .device-box {
    padding-right: 10px;
    border-radius: 0px;
    box-shadow:
      -2px 0px 0px @base01-black-65-dark inset,
      -1px 0px 0px @base01-black-80-dark inset,
      1px 0px 0px @base01-white-90-dark;
  }
  .popup-volume combobox.device-selector > box {
    margin-bottom: 10px;
  }
  .popup-volume button.combo {
    color: @base0A;
    box-shadow: none;
  }
  .popup-volume .device-box .device-selector .combo:hover {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0A-white-65-dark;
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
  .popup-volume button {
    color: @base0A;
  }
  .popup-volume button:hover:active label {
    color: @base0A;
  }

  #gtk-combobox-popup-menu {
    color: @base0A;
    background-color: @base01;
  }
  #gtk-combobox-popup-menu menuitem:hover {
    background-color: @base0A;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base0A-white-65-dark;
  }

  /* -- power -- */
  #power button {
    color: @base08;
  }
  #power button:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base08-white-65-dark;
  }
  #power button:hover label {
    color: @base01;
  }
  #power label,
  #power button:active label {
    font-size: 17px;
    color: @base08;
  }

  #popup-power label {
    color: @base08;
  }
  #profile-header {
    margin-bottom: 10px;
    padding-bottom: 7px;
    font-size: 20px;
  }
  #profile-pic-button {
    min-width: 120px;
    min-height: 120px;
    margin: 10px 10px 17px 10px;
    padding: 0px;
    border-radius: 50%;

    background-image: url("/var/lib/AccountsService/icons/brandon.face.icon");
    background-size: contain;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base02-white-90-dark;

    animation: none;
  }

  .power-btn,
  .power-btn:hover {
    padding: 1px 14px 2px 13px;
    border-radius: 50%;
    color: @base08;
  }
  .power-btn:active,
  .power-btn:hover:active {
    padding: 2px 14px 2px 14px;
  }
  #power-actions-box button:hover:not(:active) {
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base08-white-65-dark;
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
  #power-actions-box {
    min-height: 35px;
    margin: 9px 9px 12px 9px;
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px @base02-white-90-dark;
  }
''
