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

Why not use the vendor-recommended IDEs?
========================================

-   The classic vendor-supported methods of developing firmware for MCUs
    is using a full-blown IDE like Keil, IAR, or MCU Eclipse.

-   These legacy IDE-based tools are GUI-based and can be proprietary
    and/or expensive. They have their own learning curves as they are
    advanced tools for "serious professionals".

-   The advanced GUI-based tools obscure the basic basic underlying
    concepts which aren’t really that complicated!

Hardware
--------

-   ST

    -   STM32F407G-DISC1 STF32F4 Discovery Board

-   Nuvoton

    -   NuTiny-NUC029SEE

-   NXP

    -   OM13080: LPCXpresso1125 Board

    -   OM13080: LPCXpresso1125 Board

Software
--------

-   TODO: Walkthrough build/install OpenOCD

-   TODO: Walkthrough install of ARM GCC toolchain

Resources
=========

-   [Bare Metal ARM
    Programming](http://robotics.mcmanis.com/articles/20190318_bare-metal-arm.html)
    a great guide with all the basics you need to know

-   [Blink, the HelloWorld of
    Hardware](http://robotics.mcmanis.com/articles/20130907_st-blink.html)
    another fantastic but more in-depth guide

-   [Cross compiling from Linux for the
    Cortex-M](http://robotics.mcmanis.com/articles/20190401_cross-compiling-cortex-m.html),
    also targeting the STM32F407

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
