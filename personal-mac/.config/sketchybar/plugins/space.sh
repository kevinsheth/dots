#!/usr/bin/env bash

sid="$1"
current_ws="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$sid" = "$current_ws" ]; then
  sketchybar --set "$NAME" background.color=0xff71CEAD icon.color=0xff11221C
else
  sketchybar --set "$NAME" background.color=0x00000000 icon.color=0xffe6d8ba
fi
