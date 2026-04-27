#!/usr/bin/env bash

has_builtin_display=0

if ioreg -rd1 -c AppleBacklightDisplay 2>/dev/null | grep -q .; then
  has_builtin_display=1
fi

if [ "$has_builtin_display" -eq 1 ]; then
  sketchybar --bar y_offset=36 height=34
else
  sketchybar --bar y_offset=6 height=34
fi
