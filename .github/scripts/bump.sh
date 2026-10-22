#!/usr/bin/env bash
#
# Moves each cask to its app's latest GitHub release: rewrites `version`, then
# `sha256` from the DMG that version's `url` points at. Casks already current
# are left alone. Needs gh (authenticated) and curl.
#
#   .github/scripts/bump.sh              # every cask
#   .github/scripts/bump.sh cota cafe    # just these
set -euo pipefail
cd "$(dirname "$0")/../.."

if [ $# -eq 0 ]; then
  set -- $(basename -s .rb Casks/*.rb)
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for cask in "$@"; do
  file="Casks/$cask.rb"
  [ -f "$file" ] || { echo "::error::no $file"; exit 1; }

  repo="$(sed -n 's|^  homepage "https://github.com/\([^"]*\)".*|\1|p' "$file")"
  current="$(sed -n 's/^  version "\(.*\)"/\1/p' "$file")"
  latest="$(gh release view --repo "$repo" --json tagName -q .tagName)"
  latest="${latest#v}"

  if [ "$latest" = "$current" ]; then
    echo "$cask $current: up to date"
    continue
  fi

  # The url line, with the cask's #{version} filled in.
  url="$(sed -n 's/^  url "\(.*\)"/\1/p' "$file" | sed "s/#{version}/$latest/g")"
  curl -fsSL -o "$tmp/$cask.dmg" "$url"
  sha="$(shasum -a 256 "$tmp/$cask.dmg" | cut -d' ' -f1)"

  sed -i.bak -e "s/^  version \".*\"/  version \"$latest\"/" \
             -e "s/^  sha256 \".*\"/  sha256 \"$sha\"/" "$file"
  rm -f "$file.bak"
  echo "$cask $current -> $latest ($sha)"
done
