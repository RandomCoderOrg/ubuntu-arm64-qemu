#!/usr/bin/env bash

#shellcheck source=plugins/colors-and-fun.sh
source ./plugins/colors-and-fun.sh

link="https://github.com/RandomCoderOrg/ubuntu-arm64-qemu/releases/download/test-v01/qemu-ubuntu-18-test.tgz"
WORK_DIR="${HOME}/hippo-new-qemu"
curpwd="$(pwd)"

if [ "$(id -u)" != 0 ]; then
    if command -v sudo >> /dev/null 2>&1; then
        SUDO="sudo"
    fi
fi

function download()
{
    if [ ! -f "${HOME}/$(basename ${link})" ]; then
        bash plugins/download.sh "${link}"
        mv "$(basename ${link})" "$HOME"
    fi
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
    tar -xf "${HOME}"/"$(basename ${link})" -C "$HOME"

    cd "$WORK_DIR" || die "Failed"
    for item in $(ls); do
        lz4 -d "$item" "$(echo "$item" | cut -d "." -f -2)" || die "failed.."
        rm -rf "$item"
    done
    # cd "${curpwd}" || die "failed.."
}

function cleanup()
{
    msg "\nCleanUp.."
    lwarn "Removing $WORK_DIR"
    rm -rvf "$WORK_DIR"
    msg "Done.."
}

trap 'cleanup; exit 1;' HUP INT TERM

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
cp "${curpwd}"/boot.sh "$WORK_DIR"
msg "Done"

shout "Now you can start ubuntu with command ${GREEN}${WORK_DIR}/boot.sh${DC}"
