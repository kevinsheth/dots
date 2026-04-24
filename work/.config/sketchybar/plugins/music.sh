#!/usr/bin/env bash

label="--"

if [ -n "$INFO" ]; then
  track=$(printf '%s' "$INFO" | /usr/bin/plutil -extract Name raw -o - - 2>/dev/null)
  artist=$(printf '%s' "$INFO" | /usr/bin/plutil -extract Artist raw -o - - 2>/dev/null)
  state=$(printf '%s' "$INFO" | /usr/bin/plutil -extract Player State raw -o - - 2>/dev/null)

  if [ "$state" = "Playing" ] && [ -n "$track" ]; then
    if [ -n "$artist" ]; then
      label="$track - $artist"
    else
      label="$track"
    fi
  else
    label="Paused"
  fi
else
  state=$(/usr/bin/osascript -e 'tell application "Music" to if it is running then player state as text' 2>/dev/null)
  if [ "$state" = "playing" ]; then
    track=$(/usr/bin/osascript -e 'tell application "Music" to name of current track as text' 2>/dev/null)
    artist=$(/usr/bin/osascript -e 'tell application "Music" to artist of current track as text' 2>/dev/null)
    if [ -n "$track" ] && [ -n "$artist" ]; then
      label="$track - $artist"
    elif [ -n "$track" ]; then
      label="$track"
    fi
  elif [ "$state" = "paused" ]; then
    label="Paused"
  else
    label="No Music"
  fi
fi

sketchybar --set "$NAME" label="$label"
