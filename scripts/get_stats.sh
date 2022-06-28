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

    readarray -d "/" -t path_parts <<< "$file_path"

    # shellcheck disable=SC2034
    manifest_variant="${path_parts[-1]}"
    # shellcheck disable=SC2034
    manifest_id="${path_parts[-2]}"
    # shellcheck disable=SC2034
    manifest_category="${path_parts[-3]}"

    manifest_type=$(fpcli get-type "$file_path" 2> /dev/null)
    if [[ -z "$manifest_type" ]]; then
        continue;
    fi

    if [[ "$manifest_type" == "application" ]]; then
        APPS="$APPS\n$file_path"
    fi

    if [[ "$manifest_type" == "module" ]]; then
        MODULES="$MODULES\n$file_path"
    fi
done
unset IFS

APP_COUNT=$(echo -e "$APPS" | wc -l)
APP_COUNT=$(( APP_COUNT - 1 ))
echo "Found $APP_COUNT application manifests."

MODULE_COUNT=$(echo -e "$MODULES" | wc -l)
MODULE_COUNT=$(( MODULE_COUNT - 1 ))
echo "Found $MODULE_COUNT module manifests."
