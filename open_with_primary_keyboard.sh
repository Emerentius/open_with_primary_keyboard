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

if [[ "$new_sources" != "$old_sources" ]]; then
	# This is definitely racy.
	# By avoiding changes to the setting if we already have the desired
	# setting, we avoid problems in some circumstances,
	# i.e. when a command is run multiple times in quick succession.
	# The first run will change the setting and schedule a reset to the original setting.
	# Every run thereafter will not schedule a change until the previous reset has run through.
	# If the programs all want the same primary keyboard setting, then the original setting
	# shouldn't be lost that way no matter how many processes are run.
	# If two programs want different primary keyboards, then the original setting may still be lost.

	gsettings set org.gnome.desktop.input-sources sources "$new_sources"
	nohup bash -c "(sleep 5 && gsettings set org.gnome.desktop.input-sources sources \"$old_sources\")" & disown
fi

$program "$@"

