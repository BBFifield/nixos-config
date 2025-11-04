config: pkgs: ''
  @use "${pkgs.tintednix.root}/pkgs/themes/gtk/base16-gtk/common/helpers" as h with (
    $token-mode: "css-var"
  );
  @use "${pkgs.tintednix.root}/pkgs/themes/gtk/base16-gtk/common/shadows" as s with (
    $gtk-version: "gtk4"
  );

  @import url("colors.css");

  :root {
    --night-light-color: #{h.token-resolve(base04)};
    --night-light-shadow: #{s.shadow-value(thin, base04)};

    --wallpaper-cycle-color: #{h.token-resolve(base0C)};
    --wallpaper-cycle-shadow: #{s.shadow-value(thin, base0C)};
  }

  @keyframes popover-slide-down {
    from { transform: translateY(-500px); }
    to   { transform: translateY(0px); }
  }
  @keyframes popover-slide-up {
    from { transform: translateY(0px); }
    to   { transform: translateY(-500px); }
  }
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
      background-image: radial-gradient(circle farthest-corner at center, unquote("alpha(currentColor, 1)") 100%, transparent 0%);
    }
    to {
      background-image: radial-gradient(circle farthest-corner at center, unquote("alpha(currentColor, 1)") 0%, transparent 0%);
    }
  }
  @keyframes ripple-out-base09 {
    from {
      background-image: radial-gradient(circle farthest-corner at center, unquote("alpha(var(--base09), 1)") 0%, transparent 0%);
    }
    to {
      background-image: radial-gradient(circle farthest-corner at center, unquote("alpha(var(--base09), 1)") 100%, transparent 0%);
    }
  }
  @keyframes ripple-in-base09 {
    from {
      background-image: radial-gradient(circle farthest-corner at center, unquote("alpha(var(--base09), 1)") 100%, transparent 0%);
    }
    to {
      background-image: radial-gradient(circle farthest-corner at center, unquote("alpha(var(--base09), 1)") 0%, transparent 0%);
    }
  }

  #start,
  #center,
  #end {
    min-height: 33px;
    background-color: h.token-resolve(base02);
    @include s.apply-shadow(thin, base02);
  }

  #bar {
    margin: 5px 15px 11px 15px;
    padding: 1px 0px 0px 1px;
    background-color: h.token-resolve(base01);
    @include s.apply-shadow(thin, base01);
  }

  window {
    opacity: 0.9;
    background-color: transparent;
  }

  box {
    border-radius: 50px;
  }

  button box {
    transition: none;
  }

  .container.horizontal {
    > revealer {
      > button, > box > revealer > button {
        padding: 1px 17px 2px 16px;
        &:active, &:checked {
          margin: 0px;
          padding: 2px 17px 2px 17px;
          @include s.apply-shadow(inset, base02);
        }
        &hover:checked {
          padding: 2px 17px 2px 17px;
        }
      }
    }
  }

  label,
  row,
  listview {
    color: inherit;
  }

  slider {
    color: h.token-resolve(base0D);
  }

  popover > contents {
    min-width: 50px;
    animation: popover-slide-down 200ms ease-out forwards;
  }
  popover.menu:not(:focus-within) > contents {
    animation: popover-slide-up 200ms ease-in forwards;
  }

  popover separator.horizontal {
    @include s.apply-shadow(inset-extra-thin, base01);
  }

  /* -- workspaces -- */
  .workspaces {
    margin: 0px;
    box-shadow: none;
  }
  .workspaces > button.item {
    padding: 1px 9px 2px 8px;
    color: h.token-resolve(base0F);
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }
  .workspaces > button.item:hover {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base0F);
    @include s.apply-shadow(thin, base0F);
  }
  .workspaces > button.item.inactive > label {
    opacity: 0.4;
  }
  .workspaces > button.item.inactive:hover {
    opacity: 0.5;
  }
  .workspaces > button.item.focused,
  .workspaces > button.item:active {
    margin: 0px;
    padding: 2px 9px 2px 9px;
    border-left: 0px;
    border-radius: 50px;

    color: h.token-resolve(base0F);

    background-color: h.token-resolve(base02);
    @include s.apply-shadow(inset, base02);
  }
  .workspaces > button.item + button.item:active,
  .workspaces > button.item + button.item.focused {
    margin: 0px 0px 0px 2px;
  }
  .workspaces > button:hover + button:not(.focused),
  .workspaces > button.focused + button:not(:hover) {
    border-left-color: transparent;
    box-shadow: none;
  }

  /* -- walker button -- */
  #walker-btn label {
    margin: -11px -11px -11px -16px;
    font-size: 36px;
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }

  /* -- clock -- */
  .clock > label {
    font-size: 17px;
  }
  .calendar-clock {
    margin-bottom: 1px;
    padding: 0px 29px;
    font-family: "DS-Digital", sans-serif;
    font-size: 50px;
    color: h.token-resolve(base08);
  }

  /* notifications */
  .notifications > button.text-button {
    padding: 1px 17px 2px 16px;
  }
  .notifications > button.text-button:active {
    padding: 2px 17px 2px 17px;
  }
  .notifications > button.text-button > label {
    font-size: 20px;
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }
  .notifications > .count {
    margin-top: 3px;
    margin-right: 3px;
    padding-right: 4px;
    padding-left: 4px;
    border-radius: 50%;

    font-size: 0.8rem;
    color: h.token-resolve(base01);

    opacity: 0.8;
    background-color: h.token-resolve(base0D);
  }
  overlay.notifications > button.text-button:not(:hover) {
    box-shadow: none;
  }
  overlay.notifications > button:hover:active {
    @include s.apply-shadow(inset, base02);
  }

  /*-- tools --*/
  #tools {
    color: h.token-resolve(base06);
  }
  #tools > revealer > button > label {
    margin-left: -4px;
    font-size: 19px;
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }
  #tools > revealer > button:hover:not(:active) {
    background-color: h.token-resolve(base06);
    @include s.apply-shadow(thin, base06);
  }
  .tool {
    margin: 6px 11px 11px 11px;
    padding: 1px 10px 2px 9px;
  }
  .tool > label {
    font-size: 22px;
  }
  .tool:hover:active {
    margin: 5px 11px 11px 10px;
    padding: 2px 10px 2px 10px;
    @include s.apply-shadow(inset, base01);
  }

  .nightLightOn {
    --night-light-color: #{h.token-resolve(base0A)};
    --night-light-shadow: #{s.shadow-value(thin, base0A)};
  }
  #nightLightToggle {
    color: var(--night-light-color);
  }
  #nightLightToggle:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: var(--night-light-color);
    box-shadow: var(--night-light-shadow);
  }
  #nightLightSlider {
    padding: 0px 30px;
  }

  #screenshotter {
    color: h.token-resolve(base08);
  }
  #screenshotter:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base08);
    @include s.apply-shadow(thin, base08);
  }
  #screenshotter > label {
    margin-left: -5px;
  }

  .wallpaperCycleOn {
    --wallpaper-cycle-color: #{h.token-resolve(base04)};
    --wallpaper-cycle-shadow: #{s.shadow-value(thin, base04)};
  }
  #wallpaperCycleToggle {
    color: var(--wallpaper-cycle-color);
  }
  #wallpaperCycleToggle:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: var(--wallpaper-cycle-color);
    box-shadow: var(--wallpaper-cycle-shadow);
  }
  #wallpaperCycleToggle > label {
    margin-left: -3px;
  }
  #wallpaperNavButtons.linked {
    margin: 5px 5px 10px 5px;
    background-color: h.token-resolve(base02);
  }
  .wallpaperNav {
    padding: 1px 10px 2px 9px;
    color: h.token-resolve(base0C);
  }
  .wallpaperNav:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base0C);
    @include s.apply-shadow(thin, base0C);
  }
  .wallpaperNav:active {
    margin: 0px;
    padding: 2px 10px 2px 10px;
  }

  /*-- tray -- */
  .tray > .item:active {
    @include s.apply-shadow(inset, base02);
  }
  .tray > .item > box > picture {
    -gtk-icon-shadow: 0px 0px 2px rgb(0, 0, 0);
  }
  #trayRevealer {
    > revealer > button {
      padding: 1px 9px 2px 8px;
      &:active {
        padding: 2px 9px 2px 9px;
      }
    }
  }

  /* -- sys_info -- */
  #stats-btn {
    background-color: transparent;
  }
  #stats-btn:hover {
    background-color: h.token-resolve(base0D);
  }
  #stats-btn:active {
    background-color: transparent;
  }
  #popup-stats > revealer {
    padding: 0px 6px;
  }
  .header {
    margin-bottom: 5px;
    padding-bottom: 7px;
    border-bottom: 1px solid h.token-resolve(base01-black-80-dark);
    /* shadow-separator-mimic-bottom-horizontal-base01 */
    @include s.apply-shadow(separator-bottom-horizontal, base01);
  }
  #cpu-label {
    color: h.token-resolve(base08);
  }
  #ram-label {
    color: h.token-resolve(base0E);
  }
  #disk-label {
    color: h.token-resolve(base0D);
  }
  #gpu-label {
    color: h.token-resolve(base0B);
  }
  #uptime-label {
    color: h.token-resolve(base0A);
  }

  .reveal-btn {
    margin: 10px 30px 11px 30px;
    background-color: h.token-resolve(base02);
    @include s.apply-shadow(thin, base02);
  }
  .reveal-btn:hover:not(:active) {
    background-color: h.token-resolve(base0D);
    /*shadow-thin-base0D*/
    @include s.apply-shadow(thin, base0D);
  }
  .reveal-btn:active {
    margin: 9px 30px 11px 29px;
    background-color: h.token-resolve(base02);
    @include s.apply-shadow(inset, base02);
  }
  .info {
    padding-top: 5px;
    border-top: 1px solid h.token-resolve(base01-black-80-dark);
    border-radius: 0px;
    @include s.apply-shadow(separator-horizontal, base01);
    animation: generic-slide-down 0.2s cubic-bezier(0, 0, 0.2, 1) forwards;
  }
  #distro-label {
    color: h.token-resolve(base0A);
  }
  #build-label {
    color: h.token-resolve(base0D);
  }
  #kernel-label {
    color: h.token-resolve(base08);
  }
  #hostname-label {
    color: h.token-resolve(base0B);
  }
  #packages-label {
    color: h.token-resolve(base0E);
  }
  #local-ip-label {
    color: h.token-resolve(base0C);
  }
  #public-ip-label {
    color: h.token-resolve(base06);
  }

  #colors-label {
    color: h.token-resolve(base0F);
  }

  @for $i from 0 through 9 {
    #base0#{$i} {
      color: h.token-resolve(base0#{$i});
    }
  }
  #base0A {
    color: h.token-resolve(base0A);
  }
  #base0B {
    color: h.token-resolve(base0B);
  }
  #base0C {
    color: h.token-resolve(base0C);
  }
  #base0D {
    color: h.token-resolve(base0D);
  }
  #base0E {
    color: h.token-resolve(base0E);
  }
  #base0F {
    color: h.token-resolve(base0F);
  }
  #font-label {
    color: h.token-resolve(base07);
  }
  .gtk-label {
    color: h.token-resolve(base0B);
  }

  /*-- network --*/
  #network {
    color: h.token-resolve(base0E);
  }
  #network > revealer > button > label {
    margin-right: 2px;
    font-size: 21px;
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }
  #network > revealer > button:hover:not(:active) {
    background-color: h.token-resolve(base0E);
    @include s.apply-shadow(thin, base0E);
  }
  #network > revealer > button:hover {
    color: h.token-resolve(base01);
  }
  #network > revealer > button:hover:active {
    color: h.token-resolve(base0E);
  }

  /*-- bluetooth --*/
  .bluetooth {
    color: h.token-resolve(base0C);
  }
  .bluetooth:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base0C);
    @include s.apply-shadow(thin, base0C);
  }
  .bluetooth > label,
  .bluetooth:active > label {
    font-size: 20px;
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
    background-color: transparent;
  }
  .popup-bluetooth {
    min-width: 250px;
    padding-bottom: 0px;
  }
  .popup-bluetooth,
  .popup-bluetooth .device > .spinner {
    color: h.token-resolve(base0C);
  }
  .popup-bluetooth > .header {
    border-radius: 0px;
  }
  .popup-bluetooth > .header > .switch {
    margin-right: 20px;
  }
  .popup-bluetooth .device > .icon-box {
    margin-right: 10px;
  }
  .popup-bluetooth .device > .status > .header-label {
    font-size: 16px;
    font-weight: bold;
  }
  .popup-bluetooth .device > .switch {
    margin-left: 10px;
  }
  .popup-bluetooth .device > .spinner {
    margin-left: 20px;
  }

  /* -- clipboard -- */
  .clipboard,
  .clipboard > label,
  .clipboard:hover:active > label {
    font-size: 20px;
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }
  .clipboard {
    color: h.token-resolve(base09);
  }
  .clipboard:hover:not(:active),
  .popup-clipboard button:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base09);
    @include s.apply-shadow(thin, base09);
  }

  .popup-clipboard {
    color: h.token-resolve(base09);
  }
  .popup-clipboard .btn-remove {
    margin: 10px;
    color: h.token-resolve(base09);
  }
  .popup-clipboard .btn-remove:active {
    margin: 9px 10px 10px 9px;
    color: h.token-resolve(base09);
  }
  .popup-clipboard > box > box.item {
    padding-bottom: 0.3em;
    border-bottom: 1px solid h.token-resolve(base01-black-80-dark);
    border-radius: 0%;
    @include s.apply-shadow(separator-bottom-horizontal, base01);
  }
  radio {
    margin-right: 12px;
    animation: ripple-in-base09 200ms cubic-bezier(0, 0, 0.2, 1) forwards;
  }
  radio:checked {
    @include s.apply-shadow(inset-thin, base09);
    animation: ripple-out-base09 200ms cubic-bezier(0, 0, 0.2, 1) forwards;
  }

  /* -- Volume -- */
  .volume {
    color: h.token-resolve(base0A);
  }
  .volume > label {
    margin-right: 5px;
    font-size: 19px;
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }
  .volume:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base0A);
    @include s.apply-shadow(thin, base0A);
  }

  .popup-volume {
    padding: 12px;
    color: h.token-resolve(base0A);
  }
  .device-box {
    border-radius: 0px;
  }
  .apps-box {
    padding-left: 10px;
    border-left: h.token-resolve(base01-black-80-dark);
    border-radius: 0px;
    @include s.apply-shadow(separator-vertical, base01);
  }
  .device-selector > button,
  .device-selector > popover {
    color: var(--base0A);
  }
  .device-selector > .toggle:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base0A);
    @include s.apply-shadow(thin, base0A);
  }
  .device-selector > .toggle:hover:checked {
    @include s.apply-shadow(inset, base0A);
  }
  button.btn-mute {
    color: h.token-resolve(base0A);
  }
  button.btn-mute:hover {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base0A);
  }
  button.btn-mute:hover:checked {
    @include s.apply-shadow(inset, base0A);
  }
  button.btn-mute:active {
    background-color: h.token-resolve(base02);
    @include s.apply-shadow(inset, base02);
  }
  .device-selector stack > row,
  .device-selector listview > row {
    border: none;
  }
  .device-selector listview > row:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base0A);
    @include s.apply-shadow(thin, base0A);
  }

  /* -- power -- */
  #power,
  #power > revealer > button:active {
    color: h.token-resolve(base08);
  }
  #power > revealer > button:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base08);
    @include s.apply-shadow(thin, base08);
  }
  #power label,
  #power > revealer > button:active {
    font-size: 19px;
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }

  #popup-power {
    color: h.token-resolve(base08);
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

    background-image: url("/var/lib/AccountsService/icons/${config.home.username}.face.icon");
    background-size: contain;
    @include s.apply-shadow(thin, base02);
  }

  .power-btn {
    color: h.token-resolve(base08);
  }
  .power-btn,
  .power-btn:hover {
    padding: 1px 16px 2px 15px;
    border-radius: 50%;
  }
  .power-btn:active {
    padding: 2px 16px 2px 16px;
  }
  #power-actions-box button.power-btn:hover:not(:active) {
    color: h.token-resolve(base01);
    background-color: h.token-resolve(base08);
    @include s.apply-shadow(thin, base08);
  }
  #power-actions-box {
    min-height: 35px;
    margin: 9px 9px 12px 9px;
    background-color: h.token-resolve(base02);
    @include s.apply-shadow(thin, base02);
  }
  #power-actions-box button.power-btn > label {
    text-shadow: 1px 2px 2px rgba(0, 0, 0, 0.5);
  }
  #power-actions-box > revealer:not(:last-child) > .power-btn {
    margin-right: 8px;
  }
  #power-actions-box > revealer > .power-btn > label {
    margin-right: -5px;
    margin-left: -5px;
  }
  #power-actions-box > revealer:nth-child(1) > .power-btn > label {
    margin-right: 0px;
  }
  #power-actions-box > revealer:nth-child(2) > .power-btn > label {
    margin-right: -3px;
  }
  #power-actions-box > revealer:nth-child(4) > .power-btn > label {
    margin-top: -2px;
    margin-right: -5px;
  }
''
