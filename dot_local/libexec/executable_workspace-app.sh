#!/bin/bash

set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

fail() {
  printf '%s\n' "$*" >&2
  exit 1
}

if [[ $# -ne 1 || -z "${1//[[:space:]]/}" ]]; then
  fail 'Usage: workspace-app.sh <application name or bundle ID>'
fi

app="$1"
workspace="$(aerospace list-workspaces --focused)"
[[ -n "$workspace" ]] || fail 'AeroSpace did not return a focused workspace.'

case "$(printf '%s' "$app" | tr '[:upper:]' '[:lower:]')" in
  chrome|'google chrome'|com.google.chrome)
    bundle_id='com.google.Chrome'
    ;;
  kitty|net.kovidgoyal.kitty)
    bundle_id='net.kovidgoyal.kitty'
    ;;
  finder|com.apple.finder)
    bundle_id='com.apple.finder'
    ;;
  terminal|com.apple.terminal)
    bundle_id='com.apple.Terminal'
    ;;
  safari|com.apple.safari)
    bundle_id='com.apple.Safari'
    ;;
  iterm|iterm2|com.googlecode.iterm2)
    bundle_id='com.googlecode.iterm2'
    ;;
  code|'visual studio code'|com.microsoft.vscode)
    bundle_id='com.microsoft.VSCode'
    ;;
  *)
    bundle_id=$(aerospace list-apps --format '%{app-name}|%{app-bundle-id}' |
      awk -F '|' -v query="$app" '
        !found && (tolower($1) == tolower(query) || tolower($2) == tolower(query)) {
          print $2
          found = 1
        }
      ')
    if [[ -z "$bundle_id" ]]; then
      if ! bundle_id=$(osascript -e 'on run argv
        return id of application (item 1 of argv)
      end run' "$app"); then
        fail "Cannot resolve application: $app"
      fi
    fi
    [[ -n "$bundle_id" ]] || fail "No bundle ID found for application: $app"
    ;;
esac

workspace_windows() {
  aerospace list-windows \
    --workspace "$workspace" \
    --app-bundle-id "$bundle_id" \
    --format '%{window-id}'
}

windows="$(workspace_windows)"

if [[ -n "$windows" ]]; then
  aerospace focus --window-id "${windows%%$'\n'*}"
  exit 0
fi

all_windows() {
  aerospace list-windows \
    --monitor all \
    --app-bundle-id "$bundle_id" \
    --format '%{window-id}'
}

previous_windows="$(all_windows)"

create_window() {
  case "$bundle_id" in
    com.google.Chrome)
      local profile='Personal'
      local profile_directory
      if [[ "$workspace" == '1' ]]; then
        profile='Work'
      fi
      profile_directory=$(jq -er --arg name "$profile" '
        .profile.info_cache | to_entries | map(select(.value.name == $name)) |
        if length == 1 then .[0].key
        else error("Expected exactly one Chrome profile named \($name), found \(length)")
        end
      ' "$HOME/Library/Application Support/Google/Chrome/Local State")
      open -nb "$bundle_id" --args \
        "--profile-directory=$profile_directory" --new-window
      ;;
    net.kovidgoyal.kitty)
      open -nb "$bundle_id" --args --single-instance
      ;;
    com.apple.finder)
      osascript -e 'tell application "Finder" to make new Finder window' > /dev/null
      ;;
    com.apple.Terminal)
      osascript -e 'tell application "Terminal" to do script ""' > /dev/null
      ;;
    com.apple.Safari)
      osascript -e 'tell application "Safari" to make new document' > /dev/null
      ;;
    com.googlecode.iterm2)
      osascript -e 'tell application "iTerm" to create window with default profile' > /dev/null
      ;;
    com.microsoft.VSCode)
      open -nb "$bundle_id" --args --new-window
      ;;
    *)
      if [[ -n "$previous_windows" ]]; then
        fail "$app is open in another workspace and has no configured new-window method. Existing windows were left in place."
      fi
      open -b "$bundle_id"
      ;;
  esac
}

create_window

for ((attempt = 0; attempt < 100; attempt++)); do
  windows="$(all_windows)"
  new_window=''
  while IFS= read -r window; do
    [[ -n "$window" ]] || continue
    case $'\n'"$previous_windows"$'\n' in
      *$'\n'"$window"$'\n'*) ;;
      *)
        new_window="$window"
        break
        ;;
    esac
  done <<< "$windows"

  if [[ -n "$new_window" ]]; then
    current_windows="$(workspace_windows)"
    case $'\n'"$current_windows"$'\n' in
      *$'\n'"$new_window"$'\n'*) ;;
      *)
        aerospace move-node-to-workspace --window-id "$new_window" "$workspace"
        ;;
    esac
    aerospace focus --window-id "$new_window"
    exit 0
  fi
  if ((attempt < 99)); then
    sleep 0.1
  fi
done

fail "No new window appeared for $app after 100 checks. Existing windows were left in place."
