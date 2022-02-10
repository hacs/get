#!/bin/bash
# wget -O - https://get.hacs.xyz | bash -
set -e

RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
GREEN_YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

declare haPath
declare -a paths=(
    "$PWD"
    "$PWD/config"
    "/config"
    "$HOME/.homeassistant"
    "/usr/share/hassio/homeassistant"
)

function info () { echo -e "${GREEN_COLOR}INFO: $1${NO_COLOR}";}
function warn () { echo -e "${GREEN_YELLOW}WARN: $1${NO_COLOR}";}
function error () { echo -e "${RED_COLOR}ERROR: $1${NO_COLOR}"; if [ "$2" != "false" ]; then exit 1;fi; }

function checkRequirement () {
    if [ -z "$(command -v "$1")" ]; then
        error "'$1' is not installed"
    fi
}

checkRequirement "wget"
checkRequirement "unzip"

info "Trying to find the correct directory..."
for path in "${paths[@]}"; do
    if [ -n "$haPath" ]; then
        break
    fi

    if [ -f "$path/home-assistant.log" ]; then
        haPath="$path"
    else
        if [ -d "$path/.storage" ] && [ -f "$path/configuration.yaml" ]; then
            haPath="$path"
        fi
    fi
done

if [ -n "$haPath" ]; then
    info "Found Home Assistant configuration directory at '$haPath'"
    cd "$haPath" || error "Could not change path to $haPath"
    if [ ! -d "$haPath/custom_components" ]; then
        info "Creating custom_components directory..."
        mkdir "$haPath/custom_components"
    fi

    info "Changing to the custom_components directory..."
    cd "$haPath/custom_components" || error "Could not change path to $haPath/custom_components"

    info "Downloading HACS"
    wget "https://github.com/hacs/integration/releases/latest/download/hacs.zip"

    if [ -d "$haPath/custom_components/hacs" ]; then
        warn "HACS directory already exist, cleaning up..."
        rm -R "$haPath/custom_components/hacs"
    fi

    info "Creating HACS directory..."
    mkdir "$haPath/custom_components/hacs"

    info "Unpacking HACS..."
    unzip "$haPath/custom_components/hacs.zip" -d "$haPath/custom_components/hacs" >/dev/null 2>&1

    info "Removing HACS zip file..."
    rm "$haPath/custom_components/hacs.zip"
    info "Installation complete."
    echo
    info "Remember to restart Home Assistant before you configure it"

    for path in $(find "$haPath/custom_components" -maxdepth 1 -type f); do
        error "Found a file in the custom_components directory: '$path' this should not be there and may cause issues not related to HACS but you will blame HACS so remove it!" false
    done

else
    echo
    error "Could not find the directory for Home Assistant" false
    echo "Manually change the directory to the root of your Home Assistant configuration"
    echo "With the user that is running Home Assistant"
    echo "and run the script again"
    exit 1
fi
