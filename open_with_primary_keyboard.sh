#!/usr/bin/env bash

# Don't exit early. We revert
# to the correct settings at the end.
# set -o errexit
set -o nounset
set -o pipefail

primary_keyboard=$1
program=$2
shift 2

old_sources=$(gsettings get org.gnome.desktop.input-sources sources)

# remove desired keyboard from list, if it's already in there
# Assuming it's only in there once.
# remove with comma, if in the middle
new_sources=${old_sources/"${primary_keyboard}, "/}
# remove at end
new_sources=${new_sources/"${primary_keyboard}"/}

new_sources="${new_sources/[/[$primary_keyboard, }"
#echo "new: $new_sources"

gsettings set org.gnome.desktop.input-sources sources "$new_sources"

$program "$@" &

gsettings set org.gnome.desktop.input-sources sources "$old_sources"

fg
