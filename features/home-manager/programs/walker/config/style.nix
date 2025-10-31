config: pkgs: ''
  @use "${pkgs.tintednix.root}/pkgs/themes/gtk/base16-gtk/common/helpers" as h with (
    $token-mode: "css-var"
  );
  @use "${pkgs.tintednix.root}/pkgs/themes/gtk/base16-gtk/common/shadows" as s with (
    $gtk-version: "gtk4"
  );

  @import url("colors.css");

  window {
    background-color: transparent;
  }

  box.box-wrapper {
    padding: 6px;
    border-radius: 10px;
    background: color-mix(in srgb, var(--base01) 100%, transparent 20%);
    @include s.apply-shadow(wide, base01);
  }
  .search-container {
    padding: 0px 6px 8px 6px; // 8px bottom is total shadow height of .box-wrapper
  }

  .item-subtext,
  .keybind-label {
    font-size: 12px;
    opacity: 0.5;
  }
  .keybind-bind {
    font-size: 12px;
  }
  .item-image {
    margin-right: 10px;
  }
  .calc .item-text {
    font-size: 24px;
  }
  .symbols .item-image {
    font-size: 24px;
  }
  .todo.done .item-text-box {
    opacity: 0.25;
  }
  .todo.urgent {
    font-size: 24px;
  }
  .todo.active {
    font-weight: bold;
  }

  box.content-container {
    border-bottom: 1px solid var(--base01-black-80-dark);
    @include s.apply-shadow(separator-bottom-horizontal, base01);
  }
  gridview {
    box-shadow: none;
    background-color: transparent;
    margin: 2px 0px;
    padding: 0px;
    border-radius: 0px;
  }
  gridview > child.activatable {
    margin: 0px 3px;
    padding: 1px 4px;
    border-radius: 50px;
  }
  gridview > child.activatable:selected {
    background-color: var(--base01);
    @include s.apply-shadow(inset, base01);
  }

  .normal-icons {
    -gtk-icon-size: 16px;
  }
  .large-icons {
    -gtk-icon-shadow:
      1px 2px 2px rgba(0, 0, 0, 0.17),
      2px 4px 4px rgba(0, 0, 0, 0.2);
    -gtk-icon-size: 40px;
  }
  .preview > .preview-box > .preview-stack > box > .large-icons {
    -gtk-icon-size: 64px;
  }
  .item-box {
    padding: 10px;
  }
  .item-quick-activation {
    background: var(--base03);
    border-radius: 5px;
    padding: 10px;
    @include s.apply-shadow(thin, base03);
  }

  box.preview {
    margin-bottom: 8px;
  }
  viewport {
    margin: 0px;
  }
''
