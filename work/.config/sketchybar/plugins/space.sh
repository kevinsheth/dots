#!/usr/bin/env bash

sid="$1"
current_ws="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$sid" = "$current_ws" ]; then
  sketchybar --set "$NAME" background.color=0xff509475 icon.color=0xff111c18 border_color=0xff63b07a
else
  sketchybar --set "$NAME" background.color=0xd923372b icon.color=0xffc1c497
fi
