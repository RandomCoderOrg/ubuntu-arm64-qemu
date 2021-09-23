#!/usr/bin/env bash

#shellcheck source=plugins/colors-and-fun.sh
source ./plugins/colors-and-fun.sh

link="https://github.com/RandomCoderOrg/ubuntu-arm64-qemu/releases/download/test-v01/qemu-ubuntu-18-test.tgz"
WORK_DIR="${HOME}/hippo-qemu"

if [ "$(id -u)" != 0 ]; then
    if command -v sudo >> /dev/null 2>&1; then
        SUDO="sudo"
    fi
fi

function download()
{
    mkdir -p "$WORK_DIR"
    bash plugins/download.sh "${link}"    
}

function setup_dependencies()
{
    if command -v qemu-system-aarch64 >> /dev/null;  then
       $SUDO apt install qemu-system-aarch64 -y || die "Couldn't install 'qemu-system-aarch64'"
    fi
    if command -v lz4 >> /dev/null;  then
       $SUDO apt install lz4 -y || die "Couldn't install 'lz4'"
    fi
}

function start_extract_sequence()
{
    cd "$WORK_DIR" || die "failed.."
    tar -xf "$WORK_DIR/$(basename ${link})"
    FILE_BUFFER="$(ls "$WORK_DIR")"

    for item in $FILE_BUFFER; do
        lz4 -d "$item" "$(cut -d "." -f -2 "$item")"
        rm -rf "$item"
    done
    cd ..
}

shout "making sure of dependencies..."
setup_dependencies
lshout "Done"
shout "Downloading..."
download
msg "Done"
shout "Starting extraction..."
lshout "This may take a while"
start_extract_sequence
msg "Done"
msg "Setting up boot.sh.."
cp boot.sh "$WORK_DIR"
msg "Done"
shout "Now you can start ubuntu with command ${GREEN}${WORK_DIR}/boot.sh${DC}"
