#!/usr/bin/env bash

CONFIG="$HOME/.config/hypr/hyprland.conf"

[[ ! -f "$CONFIG" ]] && {
  echo "Hyprland config not found"
  exit 1
}

parse() {
  grep -E '^\s*bind(m)?\s*=' "$CONFIG" \
    | sed \
      -e 's/bindm\? *= *//' \
      -e 's/ *, */,/g' \
    | awk -F',' '
    {
      mod=$1
      key=$2
      action=$3
      cmd=$4
      if (cmd == "") cmd="-"
      printf "%-20s %-10s %-18s %s\n", mod, key, action, cmd
    }'
}

header() {
  printf "%-20s %-10s %-18s %s\n" "MODS" "KEY" "ACTION" "COMMAND"
  printf "%-20s %-10s %-18s %s\n" "--------------------" "----------" "------------------" "----------------------"
}

(
  header
  parse
) | fzf \
  --ansi \
  --no-sort \
  --prompt="Hyprland Keybinds > " \
  --preview-window=hidden
