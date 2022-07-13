#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_DIR")

set -e

get_flathub_app() {
    flathub_app_id=$1
    flathub_app_type=$2
    # TODO assert that the app_id is populated
    echo "Getting Flathub app $flathub_app_id"

    destination_path="$SCRIPT_DIR/../$flathub_app_type/$flathub_app_id"
    if [[ -d "$destination_path" ]]; then
        echo "Would remove $destination_path"
    else
        echo "Will create $destination_path"
         git clone --recursive "https://github.com/flathub/$flathub_app_id.git" "$destination_path"
         rm -rf "$destination_path/.git"
         rm -f "$destination_path/flathub.json"
         rm -f "$destination_path/.gitmodules"
         rm -f "$destination_path/.gitignore"
         if [[ -f "$destination_path/$flathub_app_id.json" ]]; then
             echo "We need to convert the app manifest to YAML!"
             fpcli convert "$destination_path/$flathub_app_id.json" yaml > "$destination_path/$flathub_app_id.yaml"
             rm "$destination_path/$flathub_app_id.json"
         fi
         if [[ -f "$destination_path/$flathub_app_id.yaml" ]]; then
             fpcli resolve "$destination_path/$flathub_app_id.yaml"
         else
             echo "Where is the manifest file for $flathub_app_id?"
         fi
    fi
}

# get_flathub_app "org.mozilla.firefox.BaseApp" apps
# I'm not sure what's up with the Thunderbird repo but there's a lot of
# files in there. Will investigate at some point.
# get_flathub_app "org.mozilla.Thunderbird" apps

get_flathub_app "org.freedesktop.Sdk.Extension.haskell" extensions

# get_flathub_app "org.keepassxc.KeePassXC"
get_flathub_app "org.zotero.Zotero" apps
get_flathub_app "org.gnome.Evince" apps
get_flathub_app "de.haeckerfelix.Shortwave" apps
# get_flathub_app "org.gnome.Documents" apps
get_flathub_app "io.neovim.nvim" apps
# get_flathub_app "org.gnome.Builder" apps
# get_flathub_app "com.belmoussaoui.Authenticator" apps
# get_flathub_app " org.gnome.Lollypop" apps
# get_flathub_app "org.gnome.Calls" apps
# Not sure about gedit, I feel like I could do without it.
# get_flathub_app "org.gnome.gedit" apps
# get_flathub_app "org.gnome.eog" apps
# get_flathub_app "org.gnome.Documents" apps
# get_flathub_app "org.gnome.clocks" apps
