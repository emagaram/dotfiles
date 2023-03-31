#!/bin/bash

if [ -f /tmp/yabai_saved_window.txt ]; then
    saved_window=$(cat /tmp/yabai_saved_window.txt)
    current_space=$(yabai -m query --spaces --space | jq '.index')
    yabai -m window "$saved_window" --space "$current_space"
else
    echo "No saved window found."
fi
