#!/bin/bash
# curl -sfSL https://hacs.xyz/install | bash -

RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

declare haPath
declare -a paths=(
    "$PWD"
    "/config"
    "$HOME/.homeassistant/"
    "/usr/share/hassio/homeassistant/"
)

function checkRequirement () {
    if [ -z "$(command -v "$1")" ]; then
        echo "'$1' is not installed"
        exit 1
    fi
}

function findPath () {
    echo "Trying to find the correct directory..."
    for path in "${paths[@]}"; do
        if [ -n "$haPath" ]; then
            return
        fi

        if [ -f "$path/home-assistant.log" ]; then
            haPath=path
        else
            if [ -d "$path/.storage" ] && [ -f "$path/configuration.yaml" ]; then
                haPath=path
            fi
        fi
    done
}

checkRequirement "wget"
checkRequirement "unzip"
findPath

if [ -n "$haPath" ]; then
    echo "Found Home Assistant configuration directory at '$haPath'"
    cd "$haPath" || exit 1
    if [ ! -d "$PWD/custom_components" ]; then
        echo "Creating custom_components directory..."
        mkdir custom_components
    fi

    echo "Changing to the custom_components directory..."
    cd custom_components || exit 1

    echo "Downloading HACS"
    wget "https://github.com/hacs/integration/releases/latest/download/hacs.zip"

    if [ -d "$PWD/hacs" ]; then
        echo "HACS directory already exist, cleaning up..."
        rm -R hacs
    fi

    echo "Creating HACS directory..."
    mkdir hacs

    echo "Unpacking HACS..."
    unzip hacs.zip -d hacs

    echo "Removing HACS zip file..."
    rm hacs.zip
    echo "Installation complete"
    echo -e "${GREEN_COLOR}Installation complete.${NO_COLOR}"
    echo
    echo "Remember to restart Home Assistant before you configure it"

else
    echo
    echo -e "${RED_COLOR}Could not find the directory for Home Assistant.${NO_COLOR}"
    echo "Manually change the directory to the root of your Home Assistant configuration"
    echo "With the user that is running Home Assistant"
    echo "and run the script again"
    exit 1
fi