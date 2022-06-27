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
        manifest_urls=$(fpcli get-urls --mirror-urls "$file_path" 2> /dev/null) 

        for url in $manifest_urls; do
            echo "Found manifest URL $url"
        done
    fi
done
unset IFS
