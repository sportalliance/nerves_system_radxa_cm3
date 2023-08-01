# Changelog

This project does NOT follow semantic versioning. The version increases as
follows:

1. Major version updates are breaking updates to the build infrastructure.
   These should be very rare.
2. Minor version updates are made for every major Buildroot release. This
   may also include Erlang/OTP and Linux kernel updates. These are made four
   times a year shortly after the Buildroot releases.
3. Patch version updates are made for Buildroot minor releases, Erlang/OTP
   releases, and Linux kernel updates. They're also made to fix bugs and add
   features to the build infrastructure.

## v1.23.1

This is a bug and security fix update. It should be a low risk upgrade.

* Fixes
  * Fix CTRL+R over ssh

* Updated dependencies
  * [nerves_system_br v1.23.2](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.23.2)
  * [Buildroot 2023.02.2](https://lore.kernel.org/buildroot/87y1je6wva.fsf@48ers.dk/T/)
  * Linux 6.1.39

## v1.23.0

This is a major update that brings in Erlang/OTP 26, Buildroot 2023.02.2

* New features
  * CA certificates are included for OTP 26.

* Updated dependencies
  * [nerves_system_br v1.23.1](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.23.1)
  * [Buildroot 2023.02.2](https://lore.kernel.org/buildroot/87wn03ifbl.fsf@48ers.dk/T/)
  * [Erlang/OTP 26.0.2](https://erlang.org/download/OTP-26.0.2.README)
  * Linux 6.1.38

## v1.22.1-1

- Add ethtool

## v1.22.1

This is a bug fix and Erlang version bump from 25.2 to 25.2.3.

**This is a breaking update which can't be applied with fwup!**\
**You need to flash the board manually if you are coming from release v1.22.0 or earlier!**

- Fixes
  - Set Erlang crash dump timer to 5 seconds, so if an Erlang crash dump does
    happen, it will run for at most 5 seconds. See erlinit.conf.

- Updated dependencies
  - [nerves_system_br v1.22.3](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.22.3)
  - [Buildroot 2022.11.1](https://lore.kernel.org/buildroot/87ilh4dvax.fsf@dell.be.48ers.dk/T/#u)
  - [Linux 6.1.22](https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/)

## v1.22.0-2

**This is a breaking update which can't be applied with fwup!**\
**You need to flash the board manually if you are coming from release v1.22.0 or earlier!**

- Changes
  - Generate a random mac-address in U-Boot if necessary and pass it to the Linux kernel
    via the device tree. The generated mac-address is stored in the environment
    and is read from there on the next boot.

- Updated dependencies
  - [Linux 6.1.13](https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/)

## v1.22.0-1

**This is a breaking update which can't be applied with fwup!**\
**You need to flash the board manually if you are coming from release v1.22.0 or earlier!**

- Changes
  - Corrected led assignments in linux device tree
  - Updated the u-boot environment to read the Linux Kernel and all relevant
    device-tree overlays from the root partition. The Boot partition mmcblk0p1
    is now empty and used as a dummy to avoid having to adapt all partition
    assignments.

- Updated dependencies
  - [Linux 6.1.9](https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/)

## v1.22.0

- Changes
  - Two Buildroot patch updates and an Erlang minor version update
  - Nerves Heart v2.0 is now included. Nerves Heart connects the Erlang runtime
    to a hardware watchdog. v2.0 has numerous updates to improve information
    that you can get and also has more safeguards to avoid conditions that could
    cause a device to hang forever.

- Updated dependencies
  - [Linux 6.1.4](https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/)
  - [nerves_system_br v1.22.1](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.22.1)
  - [Erlang/OTP 25.2](https://erlang.org/download/OTP-25.2.README)
  - [Buildroot 2022.11](http://lists.busybox.net/pipermail/buildroot/2022-December/656980.html)
  - [nerves_heart v2.0.2](https://github.com/nerves-project/nerves_heart/releases/tag/v2.0.2)
  - GCC 12.2

## v1.21.1

- Changes
    - Update Linux kernel to v6.0.9
    - Update linux kernel defconfig to make it similar to the one on the [RPI4 system](https://github.com/nerves-project/nerves_system_rpi4)
        - This should fix an issue where the network couldn't connect to the router

- Updated dependencies
    - [Linux 6.0.9](https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/)
    - [nerves_system_br v1.21.2](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.21.2)
    - [Erlang/OTP 25.1.2](https://erlang.org/download/OTP-25.1.2.README)
    - [Buildroot 2022.08.1](http://lists.busybox.net/pipermail/buildroot/2022-October/652816.html)

## v1.20.2

- Dependencies
   - The dependency changelog can be seen in the [respective changelog](https://github.com/nerves-project/nerves_system_rpi4/releases/tag/v1.20.2) of the RPI4 system.

- Other Updates
   - Linux Kernel: Upstream v6.0.7
   - U-Boot Bootloader: Custom v2022.04

## v1.1.0

Updated Nerves & Dependencies

* [nerves_system_br v1.21.1](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.21.1)
* [Erlang/OTP 25.1.1](https://erlang.org/download/OTP-25.1.1.README)
* [Nerves v1.9.1](https://github.com/nerves-project/nerves/releases/tag/v1.9.1)

## v1.0.0

First working version

* [nerves_system_br v1.18.6](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.18.6)
* linux 4.19.193 with Radxa patches
* [nerves toolchain v1.4.3](https://github.com/nerves-project/toolchains/releases/tag/v1.4.3)
* [Erlang/OTP 24.3.2](https://erlang.org/download/OTP-24.3.2.README)
