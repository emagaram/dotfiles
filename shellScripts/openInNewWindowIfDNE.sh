#!/bin/bash

app_name="$*"

# Get an array of window IDs with a matching app name
window_ids=($(yabai -m query --windows | jq -r "map(select(.app == \"$app_name\")) | .[].id"))

if [ ${#window_ids[@]} -gt 0 ]; then
    # Focus the first window with the matching app name
    yabai -m window --focus "${window_ids[0]}"
else
    open -a "$app_name"
fi
