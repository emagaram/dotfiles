#!/usr/bin/env bash

windows="$(yabai -m query --spaces --space | jq '.windows')"

if [[ $windows == *","* ]]; then
    echo "2!"
    yabai -m config window_border on
    yabai -m config active_window_border_color "0xFFFFFF00"
    yabai -m config normal_window_border_color "0x000000009" #stops it from rendering
else
    echo "1"
    yabai -m config window_border off
    # yabai -m config mouse_follows_focus off
fi
