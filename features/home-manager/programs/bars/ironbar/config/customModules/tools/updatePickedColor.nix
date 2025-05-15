pkgs:
pkgs.writeShellScript "update_picked_color" ''
  new_picked_color=$(hyprpicker -a)
  pkill .wl-copy-wrappe
  ironbar var set picked_color $new_picked_color

  css_to_insert="#colorPicker { border-color: $new_picked_color; }"

  sed -i '$d' "/home/brandon/.config/ironbar/style.css"
  gawk -i inplace -v src="$css_to_insert" '{ print } ENDFILE { print src }' "/home/brandon/.config/ironbar/style.css" || echo "Failed to update settings"

  ironbar load-css "/home/brandon/.config/ironbar/style.css"
''
