#!/usr/bin/env bash

# source_file_content=$(cat "/home/brandon/.config/ironbar/style.css")
#
# touch /tmp/ironbar_style.css
# printf "%s\n"  "$source_file_content" > /tmp/ironbar_style.css
# echo "#colorPicker { border-color: #f38ba8; }" >> /tmp/ironbar_style.css
#
# source_file_content2=$(cat "/tmp/ironbar_style.css")
#
# rm /tmp/ironbar_style.css
#
# sed -i '1,$d' "/home/brandon/.config/ironbar/style.css"
# gawk -i inplace -v src="$source_file_content2" '{ print } ENDFILE { print src }' "/home/brandon/.config/ironbar/style.css" || echo "Failed to update settings"
#
# ironbar load-css "/home/brandon/.config/ironbar/style.css"

new_picked_color=$(hyprpicker -a)
pkill .wl-copy-wrappe
ironbar var set picked_color $new_picked_color

css_to_insert="#colorPicker { border-color: $new_picked_color; }"

sed -i '$d' "/home/brandon/.config/ironbar/style.css"
gawk -i inplace -v src="$css_to_insert" '{ print } ENDFILE { print src }' "/home/brandon/.config/ironbar/style.css" || echo "Failed to update settings"

ironbar load-css "/home/brandon/.config/ironbar/style.css"
