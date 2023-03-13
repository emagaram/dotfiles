#!/bin/bash

widget_id="simple-bar-index-jsx"

# Get the current "hidden" value of the widget
current_status=$(osascript -e 'tell application id "tracesOf.Uebersicht" to get hidden of widget id "'"${widget_id}"'"')

# Toggle the "hidden" value
if [[ $current_status == "true" ]]; then
    new_status="false"
else
    new_status="true"
fi

# Set the new "hidden" value for the widget
osascript -e 'tell application id "tracesOf.Uebersicht" to set hidden of widget id "'"${widget_id}"'" to "'"${new_status}"'"'
