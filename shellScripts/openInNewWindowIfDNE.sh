#!/bin/bash

app_name="$*"

# Get the ID of the currently focused window
current_id=$(yabai -m query --windows --window | jq -r ".id")

# Get an array of window IDs with a matching app name
window_ids=($(yabai -m query --windows | jq -r "map(select(.app == \"$app_name\")) | .[].id"))

found=false

for id in "${window_ids[@]}"; do
    if [ "$id" != "$current_id" ]; then
        # Focus the first window that isn't the currently focused one
        yabai -m window --focus "$id"
        found=true
        break
    fi
done

# If no other window of the app was found to focus on, open the app
if [ "$found" = false ]; then
    open -a "$app_name"
fi

