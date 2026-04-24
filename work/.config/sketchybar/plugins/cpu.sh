#!/usr/bin/env bash

load=$(ps -A -o %cpu | awk '{sum+=$1} END {printf("%.0f", sum)}')
sketchybar --set "$NAME" label="$load%"
