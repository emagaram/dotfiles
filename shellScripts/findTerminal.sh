#!/bin/zsh
openCmd="/Applications/kitty.app/Contents/MacOS/kitty "

excludedTitles=("ranger" "spotify_player")
json_excluded_titles=$(printf '%s\n' "${excludedTitles[@]}" | jq -R . | jq -s .)
if [ "$1" = "spotify_player" ]; then
    query='[.[] | select(.app == "kitty") | select(.title | test("spotify_player")) | .space][0]'
    openCmd+='--title spotify_player -e spotify_player && open -a "Spotify"'
elif [ "$1" = "ranger" ]; then
    query='[.[] | select(.app == "kitty") | select(.title | test("ranger")) | .space][0]'
    openCmd+="--title ranger -e lf"
else
    query="[.[] | select(.app == \"kitty\") | select(.title as \$title | ($json_excluded_titles | index(\$title) | not)) | .space][0]"
fi

space_number=$(yabai -m query --windows | jq -r "$query")
if [[ $space_number =~ ^[0-9]+$ ]]; then
    yabai -m space --focus "$space_number"
else
    echo "Desired window not found"
    eval $openCmd
fi
