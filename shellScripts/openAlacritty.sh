#!/bin/bash
# Run Alacritty with arguments in the background without needing a terminal open

nohup alacritty "$@" >/dev/null 2>&1 &
