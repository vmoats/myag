#!/bin/bash -e

# Config
OUTPUT_DIR="output"
BOOTLOADER_IMAGE="abl.elf"

# Log colors
GREEN="\033[0;32m"
NO_COLOR='\033[0m'

# Flash bootloader
$EDL w abl_a $OUTPUT_DIR/$BOOTLOADER_IMAGE
$EDL w abl_b $OUTPUT_DIR/$BOOTLOADER_IMAGE

echo -e "${GREEN}Done!"
