#!/usr/bin/env bash

# * Deafault color is Blue
RST="\e[0m"
RED="\e[1;31m" # *This is bold
BLUE="\e[34m"
GREEN="\e[1;32m"
DC=${BLUE}

die    () { echo -e "${RED}Error ${*}${RST}";exit 1 ;:;}
warn   () { echo -e "${RED}Error ${*}${RST}";:;}
shout  () { echo -e "${DC}-----";echo -e "${*}";echo -e "-----${RST}";:; }
lshout () { echo -e "${DC}";echo -e "${*}";echo -e "${RST}";:; }
msg    () { echo -e "${*}";:;}