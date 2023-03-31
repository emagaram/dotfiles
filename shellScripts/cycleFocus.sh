#!/bin/bash

# Attempt to focus the next window
if ! yabai -m window --focus next &>/dev/null; then
    # If the previous command fails, focus the first window
    yabai -m window --focus first
fi
