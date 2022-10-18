#!/bin/sh

set -e
# Create the revert script for manually switching back to the previously
# active firmware.
mkdir -p $TARGET_DIR/usr/share/fwup
$HOST_DIR/usr/bin/fwup -c -f $NERVES_DEFCONFIG_DIR/fwup-revert.conf -o $TARGET_DIR/usr/share/fwup/revert.fw

# Copy the fwup includes to the images dir
cp -rf $NERVES_DEFCONFIG_DIR/fwup_include $BINARIES_DIR

# Since U-Boot's squashfs support is so slow (sadly), store the Linux
# kernel in the FAT filesystem instead of /boot. See the fwup.conf for how the Image
# is put in the FAT filesystem. 
# Remove everything in /boot because all relevant files are copied to the boot partition anyways.
rm -f $TARGET_DIR/boot/*
