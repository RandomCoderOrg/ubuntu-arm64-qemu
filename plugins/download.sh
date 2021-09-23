#!/usr/bin/env bash

if [ "$(id -u)" != 0 ]; then
    if command -v sudo >> /dev/null 2>&1; then
        SUDO="sudo"
    fi
fi

if ! command -v wget >> /dev/null; then
    $SUDO apt install wget
fi

# from https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only

function progressfilt ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%s' "$c"
        else
            if [[ $c != "$cr" && $c != "$nl" ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}
function cleanup () {
    echo -e "\ncleaning up..."
    rm -rvf "$(basename "$1")"*
}
trap 'cleanup $1; exit 1;' HUP INT TERM

wget --progress=bar:force "$1"  2>&1 | progressfilt || { cleanup "$1";exit  1;:; }
