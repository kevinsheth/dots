#!/bin/bash

PERCENT="$(pmset -g batt | grep -Eo '[0-9]+%' | tr -d '%')"
STATUS="$(pmset -g batt)"

ICON=""
if [[ "$PERCENT" -lt 80 ]]; then ICON=""; fi
if [[ "$PERCENT" -lt 60 ]]; then ICON=""; fi
if [[ "$PERCENT" -lt 40 ]]; then ICON=""; fi
if [[ "$PERCENT" -lt 20 ]]; then ICON=""; fi

if echo "$STATUS" | grep -qi "charging"; then
  ICON=""
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENT}%"
