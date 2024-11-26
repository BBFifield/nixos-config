{config, ...}: let
  cfg = config.hm.walker;
in {
  layout = ''
    {
      "ui": {
        "anchors": {
          "bottom": true,
          "left": true,
          "right": true,
          "top": true
        },
        "window": {
          "box": {
            "h_align": "center",
            "margins": {
              "bottom": 0,
              "top": 0
            },
            "orientation": "vertical",
            "scroll": {
              "list": {
                "always_show": false,
                "max_entries": 300,
                "item": {
                  "activation_label": {
                    "overlay": true,
                    "h_align": "end",
                    "h_expand": true,
                    "justify": "right",
                    "x_align": 1
                  },
                  "icon": {
                    "theme": "${config.hm.theme.iconTheme}"
                  },
                  "spacing": 3,
                  "text": {
                    "h_align": "fill",
                    "h_expand": true,
                    "revert": false
                  }
                },
                "max_height": ${builtins.toString cfg.height},
                "min_height": ${builtins.toString cfg.height},
                "max_width": ${builtins.toString cfg.width},
                "min_width": ${builtins.toString cfg.width},
                "width": ${builtins.toString cfg.width}
              },
              "overlay_scrolling": true
            },
            "search": {
              "spacing": 10,
              "v_align": "start",
              "width": 400
            },
            "spacing": 10,
            "v_align": "start"
          },
          "h_align": "fill",
          "v_align": "fill"
        }
      }
    }
  '';
}
