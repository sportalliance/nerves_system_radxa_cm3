#!/bin/sh

set -e

FWUP_CONFIG=$NERVES_DEFCONFIG_DIR/fwup.conf

# Run the common post-image processing for nerves
$BR2_EXTERNAL_NERVES_PATH/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG

RKBIN=$BINARIES_DIR/rkbin
ubootName=`find $BINARIES_DIR/../build -name 'uboot-*' -type d | grep -v tools`

# We have to manually compile u-boot again because the automatically created u-boot.img does not boot
echo creating uboot.img
currentDir=`pwd`
cd $ubootName && ./make.sh || exit 1  # Abort with an error if this does not work
cd $currentDir
cp $ubootName/uboot.img $BINARIES_DIR/u-boot.itb

# Merge the rockchip binary bootloader blob with the u-boot first-stage (=SPL) loader
echo creating idbloader.img
echo $ubootName
$ubootName/tools/mkimage -n rk3568 -T rksd -d $RKBIN/bin/rk35/rk3566_ddr_1056MHz_v1.08.bin:$ubootName/spl/u-boot-spl.bin $BINARIES_DIR/idbloader.img || exit 1

# Copy all dtb files to the respective output folder (fwup will ignore most of these and only include the ones specified in fwup.conf in the final image)
linuxDir=`find $BINARIES_DIR/../build -name 'vmlinux' -type f | xargs dirname`
cp -a $NERVES_DEFCONFIG_DIR/uboot/vars.txt $BINARIES_DIR/
mkdir -p $BINARIES_DIR/rockchip/overlays
if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
  cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays
fi
cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
