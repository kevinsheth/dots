#!/usr/bin/env bash

WALLPAPER="$HOME/.config/wallpapers/osaka-jade-8k.jpg"

if [ ! -f "$WALLPAPER" ]; then
  exit 0
fi

/usr/bin/osascript <<EOF
tell application "System Events"
  tell every desktop
    set picture to POSIX file "$WALLPAPER"
  end tell
end tell
EOF
