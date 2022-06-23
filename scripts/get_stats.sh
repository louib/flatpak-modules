#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")

die() { echo "$*" 1>&2 ; exit 1; }

set -e

APPS=""
MODULES=""
# TODO also count the sources?

files=$(find "$SCRIPT_DIR/../")
IFS=$'\n'; for file in $files; do
    if [[ ! -f "$file" ]]; then
        continue
    fi

    manifest_type=$(fpcli get-type "$file" 2> /dev/null)
    if [[ -z "$manifest_type" ]]; then
        continue;
    fi

    if [[ "$manifest_type" == "application" ]]; then
        APPS="$APPS\n$file"
    fi

    if [[ "$manifest_type" == "module" ]]; then
        MODULES="$MODULES\n$file"
    fi
done
unset IFS

echo -e "Found applictions: $APPS"

APP_COUNT=$(echo -e "$APPS" | wc -l)
APP_COUNT=$(( APP_COUNT - 1 ))
echo "Found $APP_COUNT application manifests."

MODULE_COUNT=$(echo -e "$MODULES" | wc -l)
MODULE_COUNT=$(( MODULE_COUNT - 1 ))
echo "Found $MODULE_COUNT module manifests."
