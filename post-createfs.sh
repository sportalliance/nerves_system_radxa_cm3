#!/bin/sh

set -e

FWUP_CONFIG=$NERVES_DEFCONFIG_DIR/fwup.conf

# Run the common post-image processing for nerves
$BR2_EXTERNAL_NERVES_PATH/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG

# Getting uboot to work is a bit of a PITA and most of the time the build system will ignore any errors and create a nonworking image
# Here we make sure that uboot did not complain about any missing files in the build log
if grep -iq "Some images are invalid" $NERVES_DEFCONFIG_DIR/build.log; then
  echo "Uboot created an invalid image. Is the path to BL31 correct?"
  exit 1
fi

# Copy all dtb files to the respective output folder (fwup will ignore most of these and only include the ones specified in fwup.conf in the final image)
linuxDir=`find $BINARIES_DIR/../build -name 'vmlinux' -type f | xargs dirname`
cp -a $NERVES_DEFCONFIG_DIR/uboot/vars.txt $BINARIES_DIR/
mkdir -p $BINARIES_DIR/rockchip/overlays
if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
  cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays
fi
cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
