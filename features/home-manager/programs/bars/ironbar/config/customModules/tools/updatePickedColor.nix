pkgs:
pkgs.writeShellScript "update_picked_color" ''
  new_picked_color=$(hyprpicker -a | tr -d '[:space:]')
  if [ -z "$new_picked_color" ]; then
    echo "No color picked – skipping CSS update."
    exit 0
  fi

  # only runs if new_picked_color is non-empty
  ironbar var set picked_color "$new_picked_color"

  css_to_insert="#colorPicker { border: 1px solid $new_picked_color; }"

  # remove last line (old rule)
  sed -i '$d' "$HOME/.config/ironbar/style.css"

  # append new rule
  gawk -i inplace -v src="$css_to_insert" '
    { print }
    ENDFILE { print src }
  ' "$HOME/.config/ironbar/style.css" || echo "Failed to update settings"

  ironbar load-css "$HOME/.config/ironbar/style.css"
''
