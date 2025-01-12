{config}: {
  style = ''
    @import url("colors.css");
    /* -- base styles -- */
    * {
      font-family:
        ${config.hm.theme.fonts.defaultMonospace},
        sans-serif;
      font-weight: normal;
      font-size: 16px;
    }

    @keyframes slide-down {
      from {
        margin: -140px 25px 30px 25px;
      }
      to {
        margin: 10px 25px 30px 25px;
      }
    }

    #start,
    #center,
    #end {
      background-color: @base02;
    }
    #topbar {
      background-color: transparent;
    }

    #bar {
      border: 1px solid @base00;
      margin: 5px 15px 10px 15px;
      box-shadow:
        0 2px 3px 0 rgba(0, 0, 0, 0.5),
        0 3px 4px 0 rgba(0, 0, 0, 0.4);
    }

    .background {
      padding: 0px;
    }
    window {
      border-radius: ${config.hm.hyprland.buttonRounding};
      background-color: transparent;
    }
    box {
      border-radius: ${config.hm.hyprland.buttonRounding};
      background-color: @base01;
    }
    menubar {
      background-color: @base01;
    }
    button {
      transition-timing-function: linear;
      background-color: @base02;
      color: @base0D;
      border-radius: ${config.hm.hyprland.buttonRounding};
      padding: 0px 10px 0px 10px;
    }
    button .item {
      transition-duration: 0.2s;
      transition-timing-function: linear;
    }
    button box {
      transition-duration: 0.2s;
      transition-timing-function: linear;
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
      border: 1px solid @base0D;
      margin: 0px 15px 20px 15px;
      box-shadow:
        0 4px 6px 2px rgba(0, 0, 0, 0.5),
        0 6px 10px 2px rgba(0, 0, 0, 0.4);
    }
    .popup {
      transition-property: none;
      border: 1px solid @base0D;
      border-radius: ${toString config.wayland.windowManager.hyprland.settings.decoration.rounding}px;
      animation-name: slide-down;
      animation-timing-function: linear;
      animation-duration: 0.2s;
      animation-fill-mode: forwards;
      padding: 20px;
      box-shadow:
        0 4px 6px 2px rgba(0, 0, 0, 0.5),
        0 6px 10px 2px rgba(0, 0, 0, 0.4);
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


    /* -- launcher -- */
    .launcher .item {
      margin-right: 4px;
    }
    .launcher .ifix examtem:not(.focused):hover {
      background-color: @base0D;
    }
    .launcher .open {
      border-bottom: 1px solid @base07;
    }
    .launcher .focused {
      border-bottom: 1px solid @base0B;
    }
    .launcher .urgent {
      border-bottom-color: @base08;
    }
    .popup-launcher {
      padding: 0;
    }
    .popup-launcher .popup-item:not(:first-child) {
      border-top: 1px solid @base03;
    }


    /* -- music -- */
    .music:hover * {
      background-color: @base0D;
    }
    .popup-music .album-art {
      margin-right: 1em;
    }
    .popup-music .icon-box {
      margin-right: 0.4em;
    }
    .popup-music .title .icon {
      font-size: 1.7em;
    }
    .popup-music .title .label {
      font-size: 1.7em;
    }
    .popup-music .controls *:disabled {
      color: @base02;
    }
    .popup-music .volume .slider slider {
      border-radius: 100%;
    }
    .popup-music .volume .icon {
      margin-left: 4px;
    }
    .popup-music .progress .slider slider {
      border-radius: 100%;
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
      margin: 10px 30px 0px 30px;
    }
    .info {
      border-radius: 0px;
      border-top: 1px dotted @base0D;
      margin-top: 5px;
      padding-top: 5px;
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


    /* -- tray -- */
    .tray {
      margin-left: 10px;
    }


    /* -- clipboard -- */
    .clipboard {
      margin-left: 5px;
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
      border-bottom: 1px solid @base03;
      border-radius: 0%;
    }
    radiobutton radio:checked {
      -gtk-icon-source: none;
      background-image: none;
      background-color: @base09;
      border-color: @base09;
      background-clip: padding-box;
    }


    /* -- Volume -- */
    .volume > label {
      color: @base0A;
    }
    .volume:hover {
      background-color: @base0A;
    }
    .popup-volume {
      border-color: @base0A;
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
    .popup-volume button:hover {
      background-color: @base0A;
    }
    #gtk-combobox-popup-menu {
      border: 1px solid @base0A;
      background-color: @base01;
      color: @base0A;
    }
    #gtk-combobox-popup-menu menuitem:hover {
      background-color: @base0A;
      color: @base01;
      font-weight: bold;
      transition-duration: 0.2s;
      transition-timing-function: linear;
    }
    #gtk-combobox-popup-menu menuitem:hover cellview {
      font-weight: bold;
      color: @base01;
    }
    .csd.background.popup decoration {
      margin: 20px 30px 30px 30px;
      box-shadow:
        0 4px 6px 2px rgba(0, 0, 0, 0.01),
        0 6px 10px 2px rgba(0, 0, 0, 0.01);
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
      padding:0px 2px 0px 2px;
      transition-duration: 0.2s;
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
    .workspaces button:hover {
      background-color: @base03;
    }
    .workspaces button:hover > label {
      color: @base0F;
    }
    .workspaces .item.focused {
      background-color: @base0D;
      padding: 0px 30px 0px 30px;
    }
    .workspaces .item.focused > label {
      color: @base01;
      font-weight: bold;
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
    #profile-pic {
      margin-bottom: 0.6em;
    }
    .power-btn {
      padding: 0.1em 1em;
      margin: 0.3em;
    }
    #power-actions-box button:hover label {
      color: @base01;
    }
    .power-btn:hover {
      background-color: @base08;
    }
    #power-actions-box {
      background-color: @base02;
    }
    #power-actions-box > *:nth-child(1) .power-btn {
      margin-right: 1em;
    }


    /*-- bluetooth --*/
    #bluetooth button:hover {
      background-color: @base0C;
    }
    #bluetooth label {
      background-color: @base02;
      color: @base0C;
      transition-duration: 0.2s;
      transition-timing-function: linear;
    }
    #bluetooth button:hover label {
      background-color: @base0C;
      color: @base01;
    }
    #popup-bluetooth {
      border-color: @base0C;
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
      margin: 20px 0px 0px 0px;
    }
    /*# sourceMappingURL=style.css.map */
  '';
}
