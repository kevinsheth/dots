#!/usr/bin/env bash

display_count=$(sketchybar --query displays | jq 'length' 2>/dev/null)

if [ -z "$display_count" ]; then
  display_count=1
fi

if [ "$display_count" -gt 1 ]; then
  sketchybar --bar y_offset=6 height=34
else
  sketchybar --bar y_offset=36 height=34
fi
