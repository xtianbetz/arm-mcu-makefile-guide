STATUS: WORK IN PROGRESS. NOTHING TO SEE HERE.

A minimalist guide and skeleton for building, running, and debugging
firmware for ARM-based microcontrollers using C, GCC, OpenOCD, and GDB.

Goals for this Guide
====================

-   Demonstrate a minimal Makefile-based solution for building an
    extremely simple LED-blinking firmware for an ARM microcontroller
    (MCU).

-   Demonstrate a build/test/debug workflow that works entirely from the
    CLI on Linux (and eventually Mac)

-   The workflow described here should be easily adaptable to a
    continuous integration system such as Jenkins. In other words, it
    should be straightforward to automate building and publishing
    firmware binary release-candidates automatically following code
    review (i.e. no humans ever hand-build the official firmware files
    which are tested and then released).

-   Teach the basic concepts of MCU development to programmers already
    familiar with C programming on Linux/Mac.

-   Avoid copying any code with a non-free license. Some vendors provide
    code examples or supporting source files with non-free licenses.
    Instead of copying example code from these vendors, we need to
    reference datasheets and manuals.

Why not use vendor-recommended IDEs?
====================================

-   The classic vendor-supported methods of developing firmware for MCUs
    is using a full-blown GUI-based IDE like Keil, IAR, or MCU Eclipse.

-   These tools are GUI-based and can be proprietary and/or expensive.
    They also have their own learning curves as they are advanced tools
    for "serious professionals".

-   GUI-based tools can obscure the underlying concepts which aren’t
    really that complicated!

-   Using vendor-provided SDKs and their accompanying non-free licenses
    could inadvertently lock you into a particular MCU vendor. There are
    many different ARM MCU vendors you can choose from, and you should
    be able to switch when you want.

Hardware
--------

This guide targets the following MCU vendor development kits:

-   ST

    -   STM32F3DISCOVERY STM32F3 Discovery Board (STM32F303VCT6)
        (Cortex-M4)

    -   STM32F407G-DISC1 STM32F4 Discovery Board (STM32F407VGT6)
        (Cortex-M4)

-   Nuvoton

    -   NuTiny-NUC029SEE (NUC029SEE) (Cortex-M0)

-   NXP

    -   OM13080UL: LPCXpresso1125 Board (LPC1125JBD48) (Cortex-M0)

    -   OM13093UL: LPCXpresso board for LPC11C24 with CMSIS DAP probe
        (LPC11C24FBD48) (Cortex-M0)

Reading Vendor Datasheets
-------------------------

In order to enable the GPIOs, we have to find out their addresses from
the vendor datasheets. We also need to know which GPIO bank (and/or pin)
is mapped to an existing LED on the dev board (hopefully there is one).

-   Nuvoton

    -   MCU: NUC029SEE

    -   MCU Datasheet: Nuvoton NUC029xEE technical user manual
        (TRM\_NUC029xEE\_EN\_Rev1.01.pdf)

    -   SDK Datasheet: UM\_NuTiny-SDK-NUC029SEE\_EN\_Rev1.00.pdf

    -   SVD File: NUC029EE\_v1.svd (from Keil pack downloads, see link
        below)

    -   LED GPIO: GPIO1 (from "SDK Circuit Schematic" in ), from "Target
        Chip Schematic", LED is hooked up to PB.4 (Pin 10)

    -   See "Section 6.2.4 System Memory Map", "6.2.7 Register Map",
        "SDK Circuit Schematic"

    -   Register: GPB\_MFP, Offset: GCR\_BA(0x5000\_0000)+0x34 "GPIOA
        Multiple Function and Input Type Control Register"

    -   LED PIN Bit Offset: 4 (i.e. PB.4 is enabled using the fifth bit
        in the register)

    -   0x5000\_4000-0x5000\_7FFF: "GPIO Control registers"

-   ST

    -   ST STM32F407xx: look in "Memory mapping" (Section 4), "Table 10.
        register boundary addresses"

    -   0x4002\_0C00-0x4002\_0FFF: GPIOD

    -   TODO: exact register addresses of the GPIO bank we want to
        enable for use.

Software
--------

-   TODO: Walkthrough build/install OpenOCD

-   TODO: Walkthrough install of ARM GCC toolchain

Resources
=========

-   [Bare Metal ARM
    Programming](http://robotics.mcmanis.com/articles/20190318_bare-metal-arm.html)
    a great guide with all the basics you need to know.

-   [Blink, the HelloWorld of
    Hardware](http://robotics.mcmanis.com/articles/20130907_st-blink.html)
    another fantastic but more in-depth guide.

-   [Cross compiling from Linux for the
    Cortex-M](http://robotics.mcmanis.com/articles/20190401_cross-compiling-cortex-m.html)
    basics of using GCC (targeting the STM32F407)

-   [Building OpenOCD on a Fresh
    Ubuntu](http://robotics.mcmanis.com/articles/20190331_openocd-build.html)

-   [Setting up STM32F4
    Clocks](http://robotics.mcmanis.com/articles/20190519_stm32-clocks.html)
    detailed explanation of setting up accurate clocks (i.e. for USB)

-   [Retargeting the C
    Library](http://robotics.mcmanis.com/articles/20140623_retargeting-libc.html)

-   [Embed With Elliot: ARM Makefile
    Madness](https://hackaday.com/2016/03/22/embed-with-elliot-arm-makefile-madness/),
    targeting the STM32F407 MCU, specifically the
    [STM32F407G-DISC1](https://www.st.com/en/evaluation-tools/stm32f4discovery.html)
    development board, and using CMSIS standard ARM libraries.

-   [GNU ARM Embedded Toolchain for Centos
    7.3](https://web1.foxhollow.ca/?menu=centos7arm) Using the ARM GCC
    toolchain on CentOS 7.x

-   [GNU Arm Embedded Toolchain
    Downloads](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads)

-   [OpenOCD](https://github.com/xpack-dev-tools/openocd) CLI tool used
    for firmware loading and to enable interactive debugging using
    [GDB](http://openocd.org/doc/html/GDB-and-OpenOCD.html).

-   [OpenOCD for Nuvoton
    MCUs](https://github.com/OpenNuvoton/OpenOCD-Nuvoton) Customized
    (forked) OpenOCD for Nuvoton devices

-   [HIDAPI Library](https://github.com/libusb/hidapi) Cross-platform
    library for programming USB devices (used by OpenOCD)

-   [Vendor MDK5 Software Packs](https://www.keil.com/dd2/pack/) Vendor
    software packs for Keil MDK. These .pack files are just zip files
    with interesting stuff inside, even if you aren’t using Keil MDK. In
    particular we are interested in the
    [SVD](https://www.keil.com/pack/doc/CMSIS/SVD/html/svd_Format_pg.html)
    XML files which describe the hardware in a standardized
    machine-readable format.

-   [MCU Clocks and Introduction to
    Interrupts](https://www.silabs.com/community/blog.entry.html/2015/06/16/chapter_5_clockingp-g7dK)
    article about the basics of clocks on MCUs.

Youtube Videos
--------------

The following series of videos can help you understand how the Cortex-M
processors work.

-   [Learn the Fundamentals of ARM® Cortex®-M0
    Processor](https://www.youtube.com/watch?v=JH4j7fCT_o4) How a basic
    Cortex-M0 processor works

-   [How to Choose your ARM Cortex-M
    Processor](https://www.youtube.com/watch?v=qvrmOXtOpvw) Learn the
    difference between various Cortex-M processors.

-   [Efficient Software Development with ARM CMSIS
    v4](https://www.youtube.com/watch?v=ur2tv1MpS5o&t=2432s) Overview of
    the Cortex-M Microcontroller Software Interface Standard (CMSIS), a
    set of vendor-agnostic and RTOS-agnostic APIs which are implemented
    by various MCU vendors.
