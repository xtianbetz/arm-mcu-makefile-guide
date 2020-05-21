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
