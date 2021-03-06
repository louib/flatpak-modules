#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")

die() { echo "$*" 1>&2 ; exit 1; }

set -e

files=$(find "$SCRIPT_DIR/../")
IFS=$'\n'; for file in $files; do
    if [[ ! -f "$file" ]]; then
        continue
    fi

    manifest_type=$(fpcli get-type "$file" 2> /dev/null)
    if [[ -z "$manifest_type" ]]; then
        continue;
    fi

    # FIXME fpcli does not support linting the source manifests.
    if [[ "$manifest_type" == "source" ]]; then
        continue
    fi

    echo "Linting Flatpak manifest at $file."
    fpcli lint "$file"
done
unset IFS
