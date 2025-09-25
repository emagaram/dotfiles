#!/bin/bash

app_name="$*"

# Get the ID of the currently focused window
current_id=$(yabai -m query --windows --window | jq -r ".id")

# Get an array of matching windows for the app, sorted by stacking order
windows_json=$(yabai -m query --windows | jq "map(select(.app == \"$app_name\" and (.\"is-minimized\" | not) and (.\"is-hidden\" | not))) | sort_by(.space, .frame.x, .frame.y)")

# Get just the IDs
window_ids=($(echo "$windows_json" | jq -r ".[].id"))

# If no matching windows, launch the app
if [ "${#window_ids[@]}" -eq 0 ]; then
    open -a "$app_name"
    exit 0
fi

# Find the index of the currently focused window
for i in "${!window_ids[@]}"; do
    if [ "${window_ids[$i]}" = "$current_id" ]; then
        next_index=$(( (i + 1) % ${#window_ids[@]} ))
        yabai -m window --focus "${window_ids[$next_index]}"
        exit 0
    fi
done

# If current window not in the list, focus the first
yabai -m window --focus "${window_ids[0]}"
