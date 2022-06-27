#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")

die() { echo "$*" 1>&2 ; exit 1; }

set -e

file_paths=$(find "$SCRIPT_DIR/../")
IFS=$'\n'; for file_path in $file_paths; do
    if [[ ! -f "$file_path" ]]; then
        continue
    fi

    if [[ "$file_path" =~ .*yml$ || "$file_path" =~ .*yaml$ ]]; then
        echo "Trying to parse Flatpak manifest at $file_path."
        manifest_type=$(fpcli get-type "$file_path" 2> /dev/null) 
        if [[ -z "$manifest_type" ]]; then
            die "Could not parse manifest at $file_path"
        fi
    fi
done
unset IFS
