
#!/bin/bash

osascript -e 'tell application "System Preferences"
    activate
    reveal anchor "Wi-Fi" of pane id "com.apple.preference.network"
end tell'


yabai -m window --move abs:0:0

sleep 0.85

cliclick c:480,255

