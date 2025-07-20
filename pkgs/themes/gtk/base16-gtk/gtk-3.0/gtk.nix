{}: ''
  @import url("file:///home/brandon/.config/gtk-3.0/colors.css");

  * {
    font:
      normal 16px "JetBrainsMono Nerd Font",
      sans-serif;
    outline: none;
    text-decoration: none;
    transition:
      0.1s linear background-color,
      border-color,
      opacity,
      transform,
      -gtk-icon-transform;
  }

  dialog,
  .dialog-vbox,
  .titlebar {
    background-color: @base01;
  }

  :disabled {
    opacity: 0.5;
  }

  selection {
    color: @base01;
    background-color: @base0D;
  }

  sort-indicator,
  button:active sort-indicator {
    color: @base0D;
  }
  button:hover:not(:active) sort-indicator {
    color: @base01;
  }

  .list {
    background-color: @base00;
  }
  .star,
  listview .star image,
  listview row:selected .star:hover:active image,
  listview row:hover:selected .star image {
    color: @base0A;
  }
  listview row:hover .star image,
  listview row:selected .star:hover image {
    color: @base01;
  }

  splitbutton {
    border-radius: 50px;
  }
  splitbutton > separator {
    margin-right: 1px;
  }
  splitbutton:hover,
  splitbutton:hover:checked {
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  splitbutton:active,
  splitbutton:checked,
  splitbutton:hover:active,
  splitbutton:active:checked {
    background-color: inherit;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.3) inset,
      2px 4px 4px mix(@base01, black, 0.3) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  splitbutton > button:not(#_):hover,
  splitbutton > menubutton > button:not(#_):hover,
  splitbutton > menubutton > button:not(#_):checked {
    background: none;
    box-shadow: none;
  }
  splitbutton:active > button > image,
  splitbutton:active arrow,
  splitbutton:checked > button > image,
  splitbutton:checked arrow,
  splitbutton:hover:active > button > image,
  splitbutton:hover:active arrow,
  splitbutton:hover:active:checked > button > image,
  splitbutton:hover:active:checked arrow {
    color: @base0D;
  }
  splitbutton:hover > button > image,
  splitbutton:hover arrow,
  splitbutton:hover:checked > button > image,
  splitbutton:hover:checked arrow {
    color: @base01;
  }
  splitbutton:hover > separator,
  splitbutton:hover:checked > separator {
    background-color: @base01;
  }
  splitbutton:checked > separator,
  splitbutton:hover:active > separator {
    background-color: @base0D;
  }

  scale {
    min-height: 10px;
    min-width: 10px;
    padding: 12px;
  }
  scale trough {
    background-color: @base02;
    border-radius: 9px;
    min-height: 4px;
    box-shadow:
      1px 1px 1px mix(@base02, black, 0.35) inset,
      2px 2px 2px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  scale highlight {
    border-radius: 9px;
    background-color: @base0B;
  }
  scale slider {
    background-color: @base02;
    border-radius: 100%;
    min-height: 18px;
    min-width: 18px;
    margin: -9px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  scale slider:hover {
    background-color: @base0D;
  }
  scale value {
    color: @base0D;
  }
  scale marks {
    margin: 9px 0px -12px 0px;
  }
  scale marks indicator {
    min-height: 6px;
    min-width: 1px;
    color: @base0B;
  }
  scale.vertical trough {
    min-width: 4px;
  }

  scrolledwindow,
  textview {
    border-radius: 10px;
  }

  progressbar,
  levelbar {
    border-radius: 50px;
    background-color: transparent;
  }
  progressbar text {
    color: @base0D;
  }
  progressbar trough,
  progressbar progress,
  levelbar block {
    min-height: 8px;
  }
  levelbar trough {
    min-height: 0px;
  }
  levelbar.continuous block {
    border-radius: 50px;
  }
  levelbar.discrete block {
    min-width: 32px;
    margin: 0px 1px 0px 1px;
  }
  levelbar.discrete block:first-child {
    border-radius: 50px 0px 0px 50px;
  }
  levelbar.discrete block:last-child {
    border-radius: 0px 50px 50px 0px;
  }
  levelbar.discrete block:not(:first-child):not(last-child) {
    border-radius: 0px;
  }
  levelbar.discrete block.filled:not(:first-child) {
    border-left: 1px solid @base02;
  }

  progressbar progress,
  levelbar block.filled {
    background-color: @base0B;
  }
  progressbar progress {
    border-radius: 50px;
    margin: 0px -1px 0px -1px;
  }
  progressbar trough,
  levelbar trough {
    border-radius: 50px;
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.3) inset,
      2px 4px 4px mix(@base02, black, 0.3) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }

  label.in-progress {
    color: @base01;
  }

  switch {
    background: @base02;
    border-width: 1px;
    border-radius: 50px;
    color: transparent;
    padding: 3px;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  switch:checked {
    background: @base0D;
    box-shadow:
      1px 2px 2px mix(@base0D, black, 0.3) inset,
      2px 4px 4px mix(@base0D, black, 0.3) inset,
      -1px -1px 0px mix(@base0D, white, 0.1) inset;
  }
  switch slider {
    background: @base00;
    border-radius: 100%;
    min-height: 20px;
    min-width: 20px;
    border-width: 1px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }

  radiobutton {
    padding: 2px 0px 2px 0px;
    margin-right: 4px;
  }
  radio {
    background-color: @base02;
    border: 1px solid @base02;
    border-radius: 100%;
    margin: 0px 4px 0px 4px;
    padding: 2px;
    min-height: 14px;
    min-width: 14px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  radio:checked {
    border-color: transparent;
    color: @base01;
    background-color: @base0D;
    -gtk-icon-source: image(
      -gtk-recolor(
          url("file:///nix/store/02879zizdv7vmd7prks022gjfb9k43a1-adw-gtk3-5.10/share/themes/adw-gtk3-dark/gtk-3.0/assets/bullet-symbolic.svg")
        ),
      -gtk-recolor(
          url("file:///nix/store/02879zizdv7vmd7prks022gjfb9k43a1-adw-gtk3-5.10/share/themes/adw-gtk3-dark/gtk-3.0/assets/bullet-symbolic.symbolic.png")
        )
    );
    box-shadow:
      1px 2px 2px mix(@base0D, black, 0.3) inset,
      2px 4px 4px mix(@base0D, black, 0.3) inset,
      -1px -1px 0px mix(@base0D, white, 0.1) inset;
  }
  radio:indeterminate {
    border-color: transparent;
    color: @base01;
    background-color: @base0D;
    -gtk-icon-source: image(
      -gtk-recolor(
          url("file:///nix/store/02879zizdv7vmd7prks022gjfb9k43a1-adw-gtk3-5.10/share/themes/adw-gtk3-dark/gtk-3.0/assets/dash-symbolic.svg")
        ),
      -gtk-recolor(
          url("file:///nix/store/02879zizdv7vmd7prks022gjfb9k43a1-adw-gtk3-5.10/share/themes/adw-gtk3-dark/gtk-3.0/assets/dash-symbolic.symbolic.png")
        )
    );
    box-shadow:
      1px 2px 2px mix(@base0D, black, 0.3) inset,
      2px 4px 4px mix(@base0D, black, 0.3) inset,
      -1px -1px 0px mix(@base0D, white, 0.1) inset;
  }
  checkbutton {
    padding: 2px 0px 2px 0px;
  }
  checkbutton > label {
    color: @base0D;
    margin-right: 4px;
  }
  check {
    background-color: @base02;
    border-width: 1px;
    border-radius: 6px;
    margin: 0px 4px 0px 4px;
    padding: 2px;
    min-height: 14px;
    min-width: 14px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  check:checked {
    color: @base01;
    border-color: @base0D;
    background-color: @base0D;
    -gtk-icon-source: image(
      -gtk-recolor(
          url("file:///nix/store/02879zizdv7vmd7prks022gjfb9k43a1-adw-gtk3-5.10/share/themes/adw-gtk3-dark/gtk-3.0/assets/check-symbolic.svg")
        ),
      -gtk-recolor(
          url("file:///nix/store/02879zizdv7vmd7prks022gjfb9k43a1-adw-gtk3-5.10/share/themes/adw-gtk3-dark/gtk-3.0/assets/check-symbolic.symbolic.png")
        )
    );
    box-shadow:
      1px 2px 2px mix(@base0D, black, 0.3) inset,
      2px 4px 4px mix(@base0D, black, 0.3) inset,
      -1px -1px 0px mix(@base0D, white, 0.1) inset;
  }
  check:indeterminate {
    color: @base01;
    background-color: @base0D;
    -gtk-icon-source: image(
      -gtk-recolor(
          url("file:///nix/store/02879zizdv7vmd7prks022gjfb9k43a1-adw-gtk3-5.10/share/themes/adw-gtk3-dark/gtk-3.0/assets/dash-symbolic.svg")
        ),
      -gtk-recolor(
          url("file:///nix/store/02879zizdv7vmd7prks022gjfb9k43a1-adw-gtk3-5.10/share/themes/adw-gtk3-dark/gtk-3.0/assets/dash-symbolic.symbolic.png")
        )
    );
    box-shadow:
      1px 2px 2px mix(@base0D, black, 0.3) inset,
      2px 4px 4px mix(@base0D, black, 0.3) inset,
      -1px -1px 0px mix(@base0D, white, 0.1) inset;
  }

  spinbutton {
    color: @base0D;
    border-radius: 50px;
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  spinbutton:focus {
    box-shadow: none;
  }
  spinbutton > entry {
    background-color: transparent;
    box-shadow: none;
    min-width: 30px;
  }
  spinbutton button.up,
  spinbutton button.down {
    padding: 0px 5px 0px 5px;
    border-color: transparent;
    min-height: 16px;
    min-width: 24px;
  }
  spinbutton button:hover {
    color: @base01;
  }
  spinbutton button:active {
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  spinbutton.vertical button {
    padding: 0px;
    min-height: 40px;
  }
  spinbutton.vertical > entry {
    padding: 0px;
  }

  /*GTK3 Verified*/

  label {
    color: @base0D;
  }

  entry {
    color: @base0D;
    background-color: @base02;
    background-clip: padding-box;
    caret-color: @base0D;
    border-radius: 50px;
    padding: 0px 9px 0px 9px;
    outline: none;
    min-height: 34px;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  entry:focus,
  entry button:active,
  entry button:checked {
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0px mix(@base02, white, 0.1) inset;
  }
  entry image {
    color: @base0D;
  }
  entry image.left {
    margin-right: 7px;
  }
  entry image.right {
    margin-left: 7px;
  }
  entry.search {
    border: none;
  }

  button {
    color: @base0D;
    background-color: transparent;
    min-height: 24px;
    min-width: 16px;
    padding: 5px 17px 5px 17px;
    border-radius: 50px;
  }
  button:checked,
  button:active,
  button:hover:active,
  button.image-button:not(.text-button):not(.radio):checked,
  button.image-button:not(.text-button):not(.radio):active,
  button.image-button:not(.text-button):not(.radio):hover:active {
    background-color: transparent;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.3) inset,
      2px 4px 4px mix(@base01, black, 0.3) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  button:hover:not(:active) {
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  button.text-button,
  button.font,
  button.file {
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  button.text-button:active,
  button.font:active,
  button.file:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0 mix(@base02, white, 0.1) inset;
  }
  button.image-button {
    background-color: transparent;
    box-shadow: none;
  }
  button.image-button:active {
    background-color: transparent;
  }
  button:hover label {
    color: @base01;
  }
  button:active *,
  button:checked *,
  button:hover:active * {
    color: @base0D;
  }
  button:hover *,
  button:checked:active * {
    color: @base01;
  }
  button.combo {
    padding: 5px 10px 5px 10px;
  }

  toolbar {
    background-color: @base01;
  }
  toolbutton > button {
    min-height: 24px;
    min-width: 24px;
    margin-right: 5px;
    padding: 5px;
    outline-offset: 4px;
  }
  toolbar > button:active {
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.3) inset,
      2px 4px 4px mix(@base01, black, 0.3) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }

  button separator,
  button:hover:active separator {
    background-image: image(@base0D);
    opacity: 0.8;
  }
  button:hover separator {
    background-image: image(@base01);
  }

  separator {
    background-image: image(@base02);
    min-height: 1px;
    min-width: 1px;
    margin: 0px -7px 0px 0px;
    padding-right: 8px;
    background-size: 1px 1px;
    background-repeat: repeat-y;
    background-position: left;
  }
  separator.horizontal {
    background-color: @base02;
    margin: 6px 16px 6px 16px;
  }

  menubar > menuitem {
    margin: 3px;
    border-radius: 10px;
  }
  menuitem {
    border-radius: 50px;
    color: @base0D;
    padding: 4px 8px 4px 8px;
  }
  menuitem:hover {
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  menuitem:hover > label {
    color: @base01;
  }
  toolbar,
  menubar {
    background-color: @base01;
  }
  toolbar {
    border-top: 1px solid rgb(41, 47, 69);
    padding: 6px;
  }
  headerbar {
    color: @base0D;
    background-color: @base01;
    padding: 0px 7px 0px 7px;
    margin: 0px -1px 0px -1px;
    min-height: 46px;
    box-shadow:
      0px 1px 1px rgba(0, 0, 0, 0.17),
      0px 2px 4px rgba(0, 0, 0, 0.2);
  }

  tabs {
    padding: 0px 4px 0px 4px;
    margin: -1px -1px -2px -1px;
  }
  tab {
    border-radius: 50px;
    background-color: inherit;
    margin: 5px 0px 5px 0px;
    padding: 3px 12px 4px 12px;
    min-height: 30px;
    min-width: 30px;
    color: @base0D;
  }
  tab:hover label {
    color: @base01;
  }
  tab:checked {
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.3) inset,
      2px 4px 4px mix(@base01, black, 0.3) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  tab:hover:not(:checked) {
    color: @base01;
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  tab:hover:checked > label {
    color: @base0D;
  }

  header {
    background-color: transparent;
    padding: 1px;
  }
  header > button {
    margin-top: 5px;
    margin-bottom: 5px;
  }
  header > button:active {
    box-shadow:
      1px 2px 2px mix(@base00, black, 0.3) inset,
      2px 4px 4px mix(@base00, black, 0.3) inset,
      -1px -1px 0px mix(@base00, white, 0.1) inset;
  }
  scrolledwindow > textview.view {
    border-radius: 0px;
    color: @base0D;
    background-color: transparent;
  }

  frame > scrolledwindow {
    padding-left: 6px;
    padding-right: 6px;
    padding-top: 8px;
    padding-bottom: 8px;
  }
  frame {
    color: @base0D;
    border-radius: 10px;
    background-color: transparent;
  }
  frame > label {
    margin: 4px;
  }
  button > box > arrow {
    color: @base0D;
    min-height: 16px;
    min-width: 16px;
  }
  scrolledwindow {
    background-color: @base01;
    border-radius: 0px;
    border: 0px solid @base02;
  }

  treeview.view {
    padding-top: 5px;
    padding-bottom: 5px;
    padding-left: 8px;
    padding-right: 8px;
    margin-bottom: 2px;
  }
  treeview.view * {
    color: @base0D;
  }
  treeview.view *:hover {
    color: @base01;
  }
  treeview.view *:hover:not(check) {
    background-color: @base0D;
  }
  treeview.view *:focus {
    color: @base0D;
  }
  treeview.view *:focus:not(check),
  treeview.view button:active {
    color: @base0D;
    background-color: transparent;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.3) inset,
      2px 4px 4px mix(@base01, black, 0.3) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  treeview.view button:hover:focus * {
    color: @base0D;
  }
  treeview.view radio:checked,
  treeview.view check:checked {
    color: @base01;
  }
  treeview.view button:hover:not(:active):not(:focus) * {
    color: @base01;
  }

  scrollbar trough slider {
    border-radius: 50px;
    padding: 1px;
    margin-bottom: 5px;
    margin-right: -20px;
    margin-left: 20px;
    background-color: @base0D;
  }
  scrollbar trough:hover slider {
    margin-left: 15px;
  }
  scrollbar trough slider:hover {
    margin-left: 15px;
  }
  scrollbar trough slider:focus {
    margin-left: 15px;
  }
  scrollbar:hover slider {
    margin-left: 15px;
  }

  scrollbar {
    opacity: 0.5;
  }
  scrollbar .down {
    margin-bottom: -50px;
    opacity: 0;
  }
  scrollbar .up {
    margin-top: -50px;
    opacity: 0;
  }

  tooltip {
    border: 1px solid @base0D;
    border-radius: 50px;
    color: @base0D;
    background-color: @base02;
    margin: 0px 30px 45px 15px;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3);
  }

  tooltip label {
    padding: 0px 6px 0px 6px;
  }

  statusbar frame box,
  statusbar frame border {
    background-color: @base01;
  }

  .popup menuitem:disabled {
    opacity: 0.5;
  }
  .popup menuitem {
    padding: 0px 0px 0px 0px;
    min-height: 32px;
    min-width: 120px;
  }
  .popup menuitem label:first-child {
    margin-left: -18px;
  }
  .popup menuitem {
    padding-right: 12px;
  }
  .popup menuitem:hover {
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0px rgba(255, 255, 255, 0.2);
  }
  .popup menu {
    padding: 6px;
  }
  .popup label * {
    opacity: 0.5;
  }

  .popup {
    border-radius: 10px;
    border: 1px solid @base0D;
  }
  .popup decoration {
    background-color: @base01;
  }
  decoration {
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3);
    margin: 0px 30px 45px 15px;
  }

  window {
    background-color: @base01;
  }
  window.background > box {
    background-color: @base01;
  }
  window > *:not(headerbar) {
    border-radius: 10px;
  }
  window > box > label {
    color: @base0D;
  }

  /* container */
  .linked {
    border-radius: 50px;
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0 rgba(255, 255, 255, 0.2);
  }
  /* entry unchecked */
  .linked > entry:not(:focus) {
    box-shadow: none;
  }
  /* all inset / active / checked styles */
  .linked > button:active,
  .linked > button:checked,
  .linked > button:hover:active,
  .linked > button:hover:checked,
  .linked > button.image-button:hover:active:focus,
  buttonbox.linked > button.text-button:focus,
  buttonbox.linked > button.text-button:hover:focus,
  stackswitcher.linked > button.text-button:checked,
  stackswitcher.linked > button.text-button:active,
  stackswitcher.linked > button.text-button:hover:checked {
    color: @base0D;
    background-color: @base02;
    border-radius: 50px;
    border-color: transparent;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0 mix(@base02, white, 0.1) inset;
  }

  /* simple hover on any button */
  .linked > button:hover {
    background-color: @base0D;
  }
  /* reset for text-buttons */
  .linked > button.text-button {
    background-color: transparent;
    box-shadow: none;
  }
  .linked > button.text-button:hover,
  .linked > button.image-button:hover:not(:checked):not(:active) {
    border-color: transparent;
    border-radius: 50px;
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0 rgba(255, 255, 255, 0.2);
  }
  .linked > entry:focus + *,
  .linked > button.text-button:hover + button.text-button,
  .linked > button.text-button:active + button.text-button,
  .linked > button.text-button:checked + button.text-button,
  .linked > button.text-button:hover:active + button.text-button,
  .linked > button.text-button:hover:checked + button.text-button,
  .linked > button.image-button:hover + button.image-button,
  buttonbox.linked > button.text-button:focus + button.text-button,
  buttonbox.linked > button.text-button:hover:focus + button.text-button {
    border-color: transparent;
  }

  /*  Linked widgets that function as tabs  */
  .linked:not(buttonbox)
    > button.text-button:nth-child(1):hover:not(:active):not(:checked),
  buttonbox.linked
    > button.text-button:nth-child(1):hover:not(:active):not(:focus) {
    background-color: @base0B;
  }
  .linked > button.text-button:nth-child(1):not(:hover) *,
  .linked > button.text-button:nth-child(1):active *,
  .linked > button.text-button:nth-child(1):checked *,
  buttonbox.linked > button.text-button:nth-child(1):focus * {
    color: @base0B;
  }
  .linked:not(buttonbox)
    > button.text-button:nth-child(2):hover:not(:active):not(:checked),
  buttonbox.linked
    > button.text-button:nth-child(2):hover:not(:active):not(:focus) {
    background-color: @base08;
  }
  .linked > button.text-button:nth-child(2):not(:hover) *,
  .linked > button.text-button:nth-child(2):active *,
  .linked > button.text-button:nth-child(2):checked *,
  buttonbox.linked > button.text-button:nth-child(2):focus * {
    color: @base08;
  }
  .linked:not(buttonbox)
    > button.text-button:nth-child(3):hover:not(:active):not(:checked),
  buttonbox.linked
    > button.text-button:nth-child(3):hover:not(:active):not(:focus) {
    background-color: @base0A;
  }
  .linked > button.text-button:nth-child(3):not(:hover) *,
  .linked > button.text-button:nth-child(3):active *,
  .linked > button.text-button:nth-child(3):checked *,
  buttonbox.linked > button.text-button:nth-child(3):focus * {
    color: @base0A;
  }
  .linked:not(buttonbox)
    > button.text-button:nth-child(4):hover:not(:active):not(:checked),
  buttonbox.linked
    > button.text-button:nth-child(4):hover:not(:active):not(:focus) {
    background-color: @base09;
  }
  .linked > button.text-button:nth-child(4):not(:hover) *,
  .linked > button.text-button:nth-child(4):active *,
  .linked > button.text-button:nth-child(4):checked *,
  buttonbox.linked > button.text-button:nth-child(4):focus * {
    color: @base09;
  }

  /* edge-button rounding + inter-button borders */
  .linked:not(buttonbox)
    > :first-child:not(:last-child):not(:checked):not(:hover) {
    border-radius: 50px 0 0 50px;
  }
  .linked:not(buttonbox)
    > :last-child:not(:first-child):not(:checked):not(:hover),
  buttonbox.linked > button:backdrop {
    border-radius: 0 50px 50px 0;
  }
  .linked
    > *:not(.model):not(:focus):not(:checked)
    + *:not(.model):not(:hover):not(:checked),
  .linked > .model:not(:hover) + .model {
    border-left: 1px dotted @base00;
  }
  .linked
    > *:not(.model):not(:focus):not(:checked)
    + *:not(.model):not(:hover):not(:checked),
  .linked > .model:not(:hover) + .model {
    padding: 5px 17px 5px 16px;
  }
  .linked > * + *:not(:last-child) {
    border-radius: 0;
  }
  .linked > entry + button:hover,
  .linked > entry + button:active,
  .linked > entry + button:focus:checked,
  .linked > entry + button:hover:focus:active {
    border-left: transparent;
    border-top-left-radius: 0px;
    border-bottom-left-radius: 0px;
  }
  stackswitcher {
    padding: 0px 1px 0px 1px;
    margin: 1px;
  }

  box.linked > combobox > box.linked {
    box-shadow: none;
  }

  combobox arrow {
    -gtk-icon-source: -gtk-icontheme("pan-down-symbolic");
    min-height: 16px;
    min-width: 16px;
  }

  /*This might be needed*/
  placessidebar {
    background-color: @base01;
  }

  row {
    border-radius: 50px;
    border-bottom-color: transparent;
    background-color: transparent;
    margin: 0px 4px 0px 4px;
    min-height: 36px;
  }
  row > revealer {
    padding: 0px 14px 0px 14px;
  }
  row box > image {
    padding-right: 8px;
  }
  row box > label {
    padding-right: 2px;
  }
  row box > button {
    margin: 3px 0px 3px 0px;
  }
  row:hover:not(:selected) label {
    color: @base01;
  }
  row:hover {
    border-bottom-color: @base0D;
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0 rgba(255, 255, 255, 0.2);
  }
  columnview row:selected,
  row.sidebar-row:selected,
  row:selected:backdrop,
  row:selected {
    color: @base0D;
    background-color: inherit;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.3) inset,
      2px 4px 4px mix(@base01, black, 0.3) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }
  row.activatable:hover:not(:selected) {
    color: @base01;
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0 rgba(255, 255, 255, 0.2);
  }
  .list {
    background-color: @base00;
  }

  popover list.view > row.activatable:selected:not(:hover) {
    box-shadow: unset;
  }
  popover list.view > row.activatable:hover {
    background-color: @base0D;
    color: @base01;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0 rgba(255, 255, 255, 0.2);
  }
  popover list.view > row.activatable:focus,
  popover list.view > row.activatable:focus:selected {
    background-color: @base01;
    color: @base0D;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.3) inset,
      2px 4px 4px mix(@base01, black, 0.3) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }

  .view > row.activatable:selected,
  .view > child.activatable:selected,
  list:not(.navigation-sidebar) > row.activatable:not(.sidebar-row):selected {
    box-shadow:
      1px 2px 2px mix(@base00, black, 0.3) inset,
      2px 4px 4px mix(@base00, black, 0.3) inset,
      -1px -1px 0px mix(@base00, white, 0.1) inset;
  }

  stack.view {
    background-color: @base00;
  }
  stack.view scrolledwindow treeview {
    background-color: @base00;
  }

  stack > button:not(:hover):not(.toggle):not(.image-button) {
    background-color: @base02;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0 rgba(255, 255, 255, 0.2);
  }
  stack > button:active {
    background-color: @base02;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0 mix(@base02, white, 0.1) inset;
  }
  stack > scrolledwindow > viewport {
    border-radius: 10px;
    background-color: @base00;
    box-shadow:
      1px 2px 2px mix(@base02, black, 0.35) inset,
      2px 4px 4px mix(@base02, black, 0.35) inset,
      -1px -1px 0 mix(@base02, white, 0.1) inset;
  }
  /*Because list covers the viewport and its box-shadow*/
  stack > scrolledwindow > viewport > list {
    background-color: transparent;
  }

  #pathbarbox {
    background-color: @base00;
    padding: 5px 0px 0px 0px;
  }
  #pathbarbox stack {
    background-color: @base00;
  }
  #pathbarbox button {
    border-radius: 50px;
  }
  #pathbarbox button:hover {
    background-color: @base0D;
  }
  #pathbarbox button:active,
  #pathbarbox button:checked,
  #pathbarbox button:checked:hover {
    color: @base0D;
    background-color: transparent;
    box-shadow:
      1px 2px 2px mix(@base00, black, 0.35) inset,
      2px 4px 4px mix(@base00, black, 0.35) inset,
      -1px -1px 0 mix(@base00, white, 0.1) inset;
  }
  #pathbarbox button:checked:hover * {
    color: @base0D;
  }
  #pathbarbox button image,
  #pathbarbox button label {
    padding: 0px 4px 0px 4px;
  }

  stack.view scrolledwindow {
    background-color: @base00;
  }

  frame.border-inset border {
    border-width: 1px;
    border-style: solid inset inset solid;
  }
  frame.border-outset border {
    border-width: 1px;
    border-style: outset solid solid outset;
  }
  frame.border-inset border,
  frame.border-outset border,
  frame.border-groove border,
  frame.border-ridge border {
    border-color: @base02;
    border-radius: 10px;
  }
  frame.border-groove border {
    border-width: 2px;
    border-style: groove;
  }
  frame.border-ridge border {
    border-width: 2px;
    border-style: ridge;
  }

  scrolledwindow {
    background-color: @base00;
    margin: 5px;
    box-shadow:
      1px 2px 2px mix(@base00, black, 0.35) inset,
      2px 4px 4px mix(@base00, black, 0.35) inset,
      -1px -1px 0 mix(@base00, white, 0.1) inset;
  }

  button.popup {
    border: none;
    border-radius: 50px;
  }

  modelbutton {
    border-radius: 50px;
    padding: 0px 16px 0px 16px;
    min-height: 32px;
  }
  modelbutton:hover {
    background-color: @base0D;
    box-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2),
      -1px -1px 0 rgba(255, 255, 255, 0.2);
  }
  modelbutton:active,
  modelbutton:hover:active,
  modelbutton:focus {
    background-color: inherit;
    box-shadow:
      1px 2px 2px mix(@base01, black, 0.3) inset,
      2px 4px 4px mix(@base01, black, 0.3) inset,
      -1px -1px 0px mix(@base01, white, 0.1) inset;
  }

  modelbutton:active *,
  modelbutton:focus:active *,
  modelbutton:focus * {
    color: @base0D;
  }
  modelbutton:hover * {
    color: @base01;
  }

  modelbutton:hover > radio:checked,
  modelbutton:hover > check:checked,
  modelbutton:focus > radio:checked,
  modelbutton:focus > check:checked,
  modelbutton:hover:focus > radio:checked,
  modelbutton:hover:focus > check:checked {
    color: @base01;
    background-color: @base0D;
  }

  popover {
    background-color: @base01;
    border-radius: 10px;
    border: 1px solid @base0D;
    margin: 0px 55px 65px 25px;
    padding: 2px;
    box-shadow:
      4px 12px 10px rgba(0, 0, 0, 0.2),
      7px 18px 14px rgba(0, 0, 0, 0.21),
      10px 24px 18px rgba(0, 0, 0, 0.25),
      14px 30px 24px rgba(0, 0, 0, 0.3);
  }

  popover modelbutton:disabled {
    opacity: 0.5;
  }

  popover modelbutton:hover *,
  popover modelbutton:hover:not(:focus) *,
  button:hover popover modelbutton * {
    color: @base01;
  }
  popover modelbutton arrow,
  popover modelbutton:focus:hover *,
  button:hover:active popover modelbutton:active *,
  button:hover popover modelbutton *,
  button:hover:active popover modelbutton:focus * {
    color: @base0D;
  }
  popover stack {
    margin: -6px;
  }

  fontchooser entry {
    margin: 1px;
  }

  button.radio:checked {
    border-radius: 50px;
  }

  calendar {
    color: @base0D;
  }
  calendar:selected {
    background-color: @base0D;
    color: @base01;
    border-radius: 50px;
  }

  expander title > arrow {
    color: @base0D;
  }
  expander title > arrow {
    min-width: 16px;
    min-height: 16px;
    -gtk-icon-source: -gtk-icontheme("pan-end-symbolic");
  }

  expander title > arrow:dir(rtl) {
    -gtk-icon-source: -gtk-icontheme("pan-end-symbolic-rtl");
  }

  expander title > arrow:checked {
    -gtk-icon-source: -gtk-icontheme("pan-down-symbolic");
  }

  scrolledwindow > iconview *:selected {
    background-color: @base0D;
    border-radius: 10px;
  }

  #gtk-combobox-popup-menu menuitem {
    padding: 0px 16px 0px 16px;
  }
  #gtk-combobox-popup-menu menuitem:hover * {
    color: @base01;
  }
''
