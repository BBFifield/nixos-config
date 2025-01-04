{config, ...}: let
  cfg = config.hm.walker;
in {
  layout = ''
    [ui]
    fullscreen = true
    ignore_exclusive = true

    [ui.anchors]
    bottom = false
    left = false
    right = false
    top = false

    [ui.window]
    v_expand = false
    h_expand = false
    height = -1
    width = -1
    h_align = "center"
    v_align = "center"

    [ui.window.margins]
    bottom = 0
    start = 0
    end = 0
    top = 0

    [ui.window.box]
    name = "box"
    orientation = "vertical"
    spacing = 10
    v_align = "start"
    v_expand = false
    h_expand = false
    h_align = "start"
    height = -1

    [ui.window.box.margins]
    bottom = 0
    start = 0
    end = 0
    top = 0

    [ui.window.box.scroll]
    overlay_scrolling = true

    [ui.window.box.scroll.list]
    always_show = false
    max_entries = 300
    max_height = 600
    min_height = 600
    max_width = 600
    min_width = 600
    width = 600

    [ui.window.box.scroll.list.placeholder]
    max_height = 600
    min_height = 600
    max_width = 600
    min_width = 600
    width = 600
    height = 600

    [ui.window.box.scroll.list.placeholder.margins]
    top = 0

    [ui.window.box.scroll.list.item]
    spacing = 3

    [ui.window.box.scroll.list.item.activation_label]
    overlay = true
    h_align = "end"
    h_expand = true
    justify = "right"
    x_align = 1

    [ui.window.box.scroll.list.item.icon]
    theme = "MoreWaita"

    [ui.window.box.scroll.list.item.text]
    h_align = "fill"
    h_expand = true
    revert = false

    [ui.window.box.search]
    spacing = 10
    v_align = "start"
    width = 400
  '';
}
