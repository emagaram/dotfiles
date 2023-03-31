#!/bin/bash

# Get the current window's application name
app_name=$(yabai -m query --windows --window | jq '.app' | tr -d '\"')

# Check if the application name is "kitty"
if [ "$app_name" = "kitty" ]; then
    yabai -m config window_border_radius 0
else
    yabai -m config window_border_radius 13
fi
