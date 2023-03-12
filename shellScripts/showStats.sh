#!/bin/zsh

# Get system stats
date_time=$(date "+%A, %B %d %Y at %I:%M:%S %p")
battery=$(pmset -g batt | grep -o "[0-9]*%")
wifi_name=$(networksetup -getairportnetwork en0 | awk -F ': ' '{print $2}')

signal_strength=$(networksetup -getsignalstrength Wi-Fi | awk '{if (0-$NF < -70) {print "0/3"} else if (0-$NF >= -70 && 0-$NF < -60) {print "1/3"} else if (0-$NF >= -60 && 0-$NF < -50) {print "2/3"} else {print "3/3"}}' | head -1)

wifi_strength="${signal_strength}"

# Create notification message
message="📅 ${date_time}\n🔋 ${battery}\n📶 ${wifi_name} - ${wifi_strength}"

# Display notification and clear after 5 seconds
osascript -e 'display notification "'"${message}"'" with title "System Stats"'
