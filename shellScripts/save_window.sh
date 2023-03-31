#!/bin/bash

selected_window=$(yabai -m query --windows --window | jq '.id')
echo "$selected_window" >/tmp/yabai_saved_window.txt
