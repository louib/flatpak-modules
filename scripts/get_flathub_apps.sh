#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")

set -e

get_flathub_app() {
    flathub_app_id=$1
    # TODO assert that the app_id is populated
    echo "Getting Flathub app $flathub_app_id"

    destination_path="$SCRIPT_DIR/../apps/$flathub_app_id"
    if [[ -d "$destination_path" ]]; then
        echo "Would remove $destination_path"
    else
        echo "Will create $destination_path"
         git clone --depth 1 "https://github.com/flathub/$flathub_app_id.git" "$destination_path"
         rm -rf "$destination_path/.git"
         rm -rf "$destination_path/shared-modules"
         rm -f "$destination_path/flathub.json"
         rm -f "$destination_path/.gitmodules"
         if [[ -f "$destination_path/$flathub_app_id.json" ]]; then
             echo "We need to convert the app manifest to YAML!"
             # fpcli to-yaml "$destination_path/$flathub_app_id.json" "$destination_path/$flathub_app_id.yaml"
         fi
    fi
}

get_flathub_app "org.mozilla.firefox.BaseApp"
