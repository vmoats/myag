#!/bin/bash -e

# Config
OUTPUT_DIR="output"
BOOTLOADER_IMAGE="abl.elf"

# Log colors
GREEN="\033[0;32m"
NO_COLOR='\033[0m'

# Make sure we're in the correct spot
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
EDL=edl/edl
cd $DIR

flash() {
  $EDL w $1 $2 --memory=ufs | grep "Progress:"
}

# Flash bootloader
echo "Flashing bootloader..."
flash abl_a $OUTPUT_DIR/$BOOTLOADER_IMAGE
flash abl_b $OUTPUT_DIR/$BOOTLOADER_IMAGE

echo -e "${GREEN}Done!"
