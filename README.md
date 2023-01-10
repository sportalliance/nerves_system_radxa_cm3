# Generic RK3566 (Radxa CM3, ~~Pine64 SOQuartz~~) Support


This is the base Nerves System configuration for the [Radxa CM3](https://wiki.radxa.com/Rock3/CM/CM3) and ~~[Pine64 SOQuartz](https://wiki.pine64.org/wiki/SOQuartz)~~.

**Note:** The Radxa CM3 configuration is built by default.
To create a SOQuartz image you have to adapt some config files to point to the correct device tree overlays.


| Feature              | Description                     |
| -------------------- | ------------------------------- |
| CPU                  | TODO             |
| Memory               | TODO                    |
| Storage              | only eMMC supported  |
| Linux kernel         | 6.0               |
| IEx terminal         | SSH                   |
| GPIO, I2C, SPI       | Yes - [Elixir Circuits](https://github.com/elixir-circuits) |
| ADC                  | Untested                             |
| PWM                  | Untested      |
| UART                 | ttyS1 + ttyS2 + more via device tree overlay |
| Camera               | Disabled                           |
| Ethernet             | Yes                             |
| WiFi                 | Disabled, No working driver |
| HW Watchdog          | ? |

## Versioning

The version numbers of this repo are set to be compatible to the [Nerves System RPI4](https://github.com/nerves-project/nerves_system_rpi4).

E.g. v1.20.2 of this repo has the same package dependencies as v1.20.2 of the [Nerves System RPI4](https://github.com/nerves-project/nerves_system_rpi4).

This makes it easier to use this repo as a drop-in replacement for the Raspberry PI 4.

## Building

### Building for the Radxa CM3

This is the default configuration. Just call `mix deps.get` and `mix compile`.

### Building for the SOQuartz

1. Adapt the `fdtfile` definition in `uboot/vars.txt` to point to the correct device tree overlay (`rk3566-soquartz-cm4`).
    - The file is already automatically built and copied to the output directory.
1. Also don't forget to include the overlay file in `fwup.conf`
1. Change the `CONFIG_DEFAULT_DEVICE_TREE` definition in `uboot/uboot.defconfig` to `rk3566-soquartz-cm4io`

## Using

The most common way of using this Nerves System is create a project with `mix
nerves.new` and to export `MIX_TARGET=rcm3`. See the [Getting started
guide](https://hexdocs.pm/nerves/getting-started.html#creating-a-new-nerves-app)
for more information.

If you need custom modifications to this system for your device, clone this
repository and update as described in [Making custom
systems](https://hexdocs.pm/nerves/customizing-systems.html).

## Flashing

*These instructions have to be executed in the project folder, **not** the nerves_system folder!*

1. Clone, Build and Install the [rkdeveloptool](https://github.com/rockchip-linux/rkdeveloptool.git)
    - Or install install the `rkflashtool` package from your Linux repository
1. Compile the project (`mix firmware`)
1. Create the image file (`fwup -a -d _build/<target name>/nerves/images/image.img -i _build/<target name>/nerves/images/<project name>.fw -t complete`)
1. Put the board in maskrom mode and conenct it via USB to the PC
    - Radxa CM3: Power off the board, press the yellow button next to the WIFI chip, power on the board
    - Pine64 SOQuartz: Remove the eMMC module, power-on the board, connect the eMMC module again
1. `sudo rkdeveloptool db support_files/rk356x_spl_loader_ddr1056_v1.10.111.bin`
1. `sudo rkdeveloptool wl 0 _build/<target name>/nerves/images/image.img`
1. `sudo rkdeveloptool rd`

## GPIO Numbering

The RK3566 has multiple IO banks, GPIO0 to GPIO4, with each bank having 32 pins.
These banks are further divided into 4 sub-banks, GPIOx_A to GPIOx_D:
```
GPIO0_A0 - GPIO0_A7
GPIO0_B0 - GPIO0_B7
GPIO0_C0 - GPIO0_C7
GPIO0_D0 - GPIO0_D7
GPIO1_A0 - GPIO1_A7
.
.
.
GPIO4_D0 - GPIO4_D7
```

The resulting pin number can be calculated using the following formula:
```
number = <bank>*32 + <sub_bank>*8 + pin
sub_bank = <A = 0, B = 1, C = 2, D = 3>

e.g.
GPIO3_A1 = 97 (3*32 + 0*8 + 1)
GPIO4_D7 = 159 (4*32 + 3*8 + 7)
```

Check the [respective page on the CM3 wiki](https://wiki.radxa.com/Rock3/CM/CM3/pinout) for the pinout.


## Console access

The console is currently not configured.
It can be enabled by modifying the boot arguments in `uboot/vars.txt`:
```
extra_bootargs="earlyprintk console=ttyS2,1500000n8"
```

## Provisioning devices

This system supports storing provisioning information in a small key-value store
outside of any filesystem. Provisioning is an optional step and reasonable
defaults are provided if this is missing.

Provisioning information can be queried using the Nerves.Runtime KV store's
[`Nerves.Runtime.KV.get/1`](https://hexdocs.pm/nerves_runtime/Nerves.Runtime.KV.html#get/1)
function.

Keys used by this system are:

Key                    | Example Value     | Description
:--------------------- | :---------------- | :----------
`nerves_serial_number` | `"12345678"`       | By default, this string is used to create unique hostnames and Erlang node names. If unset, it defaults to part of the module's serial number.

The normal procedure would be to set these keys once in manufacturing or before
deployment and then leave them alone.

For example, to provision a serial number on a running device, run the following
and reboot:

```elixir
iex> cmd("fw_setenv nerves_serial_number 12345678")
```

This system supports setting the serial number offline. To do this, set the
`NERVES_SERIAL_NUMBER` environment variable when burning the firmware. If you're
programming MicroSD cards using `fwup`, the commandline is:

```sh
sudo NERVES_SERIAL_NUMBER=12345678 fwup path_to_firmware.fw
```

Serial numbers are stored on the MicroSD card so if the MicroSD card is
replaced, the serial number will need to be reprogrammed. The numbers are stored
in a U-boot environment block. This is a special region that is separate from
the application partition so reformatting the application partition will not
lose the serial number or any other data stored in this block.

Additional key value pairs can be provisioned by overriding the default
provisioning.conf file location by setting the environment variable
`NERVES_PROVISIONING=/path/to/provisioning.conf`. The default provisioning.conf
will set the `nerves_serial_number`, if you override the location to this file,
you will be responsible for setting this yourself.

## Linux, U-Boot and Toolchain versions

This Nerves system uses the latest mainline Linux kernel (6.0) and compiler toolchain.
The available kernel versions can be found on [kernel.org](https://mirrors.edge.kernel.org/pub/linux/kernel).

It uses a custom U-Boot repository (version 2022.04) with patches for the RK3566 chips.

## Device tree overlays

Currently almost all hw-functions are disabled via the `rk3566-radxa-cm3-spa.dtb` file.
They can be re-enabled by using the upstream `rk3566-radxa-cm3-io.dtb` or `rk3566-radxa-cm3-rpi-cm4-io.dtb`
overlay. You can do this by editing the `vars.txt` and `fwup.conf` files.
You also have to update the `BR2_LINUX_KERNEL_INTREE_DTS_NAME` definition in the `nerves_defconfig` file.

Additional overlays can be enabled in the `vars.txt` file.
Make sure to update `fwup.conf` to copy the respective overlay to the boot partition!

**Note:** The mainline Linux Kernel does not provide any Rockchip specific overlay blobs to enable specific hardware functions (Uarts, I2C, SPI, ...). You have to manually download them from the [Radxa Kernel repo](https://github.com/radxa/kernel/tree/stable-4.19-rock3/arch/arm64/boot/dts/rockchip/overlay), compile them and include them in the image.
