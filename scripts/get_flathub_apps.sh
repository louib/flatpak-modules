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
         git clone --recursive "https://github.com/flathub/$flathub_app_id.git" "$destination_path"
         rm -rf "$destination_path/.git"
         rm -rf "$destination_path/shared-modules"
         rm -f "$destination_path/flathub.json"
         rm -f "$destination_path/.gitmodules"
         if [[ -f "$destination_path/$flathub_app_id.json" ]]; then
             echo "We need to convert the app manifest to YAML!"
             fpcli to-yaml "$destination_path/$flathub_app_id.json"
             rm "$destination_path/$flathub_app_id.json"
         fi
         if [[ -f "$destination_path/$flathub_app_id.yaml" ]]; then
             fpcli resolve "$destination_path/$flathub_app_id.yaml"
         else
             echo "Where is the manifest file for $flathub_app_id?"
         fi
    fi
}

# get_flathub_app "org.mozilla.firefox.BaseApp"
# I'm not sure what's up with the Thunderbird repo but there's a lot of
# files in there. Will investigate at some point.
# get_flathub_app "org.mozilla.Thunderbird"

# get_flathub_app "org.keepassxc.KeePassXC"
get_flathub_app "org.zotero.Zotero"
get_flathub_app "org.gnome.Evince"
get_flathub_app "de.haeckerfelix.Shortwave"
get_flathub_app "org.gnome.Documents"
# get_flathub_app " org.gnome.Lollypop"
# get_flathub_app "org.gnome.Calls"
# Not sure about gedit, I feel like I could do without it.
# get_flathub_app "org.gnome.gedit"
# get_flathub_app "org.gnome.eog"
# get_flathub_app "org.gnome.Documents"
# get_flathub_app "org.gnome.clocks"
# get_flathub_app "org.gnome.Builder"
