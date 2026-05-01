#!/usr/bin/env bash

battery_info=$(pmset -g batt)
percent=$(echo "$battery_info" | grep -Eo '[0-9]+%' | head -n1)
state=$(echo "$battery_info" | grep -Eo 'charging|discharging|charged|AC attached' | head -n1)

icon="BAT"
if [ "$state" = "charging" ] || [ "$state" = "AC attached" ]; then
  icon="CHG"
fi

if [ -z "$percent" ]; then
  percent="--%"
fi

sketchybar --set "$NAME" icon="$icon" label="$percent"
