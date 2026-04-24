#!/usr/bin/env bash

app_name="$INFO"

if [ -z "$app_name" ]; then
  app_name=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
fi

if [ -z "$app_name" ]; then
  app_name="Desktop"
fi

sketchybar --set "$NAME" label="$app_name"
