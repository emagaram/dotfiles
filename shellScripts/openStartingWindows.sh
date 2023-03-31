#!/bin/bash

apps=("Google Chrome" "Alacritty" "Spotify" "Microsoft Word")
for app in "${apps[@]}"; do
    sleep 0.2
    ~/dotfiles/shellScripts/openInNewWindowIfDNE.sh "$app"
done
