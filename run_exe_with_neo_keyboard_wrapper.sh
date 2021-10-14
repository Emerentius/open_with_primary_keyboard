#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Execute the program with the same name as this script
# but with the neo keyboard active.
# This file needs to be placed in a directory that's earlier
# on the PATH than the wrapped executable.

current_dir=$(realpath $(dirname "$0"))
program_to_run=$(basename "$0")

# If the wrapper is in the same dir, we can't run it without
# specifying the full path after deleting the current dir

OLD_PATH="$PATH"
export PATH=$(echo "$PATH" | sed "s;$current_dir:;;g")
real_program_path=$(which $program_to_run)
export PATH="$OLD_PATH"

open_with_neo_keyboard.sh $real_program_path "$@"
