#!/usr/bin/env bash
input=$(cat)
model=$(jq -r '.model.display_name' <<<"$input")
dir=$(jq -r '.workspace.current_dir' <<<"$input")
printf '%s | %s | %s' "$(date +%H:%M)" "${dir/#$HOME/\~}" "$model"
