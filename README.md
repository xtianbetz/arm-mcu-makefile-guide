STATUS: WORK IN PROGRESS. NOTHING TO SEE HERE.

A minimalist guide and skeleton for building, running, and debugging
firmware for ARM-based microcontrollers.

You will use **only** the following software tools:

-   Make, for orchestrating build tasks

-   GNU GCC and LD, for compiling ARM binaries

-   OpenOCD, for flashing firmware and interactive debugging.

-   GDB, for interactive debugging via OpenOCD.

-   Your favorite text editor, for editing source files.

-   Your favorite terminal emulator, for doing CLI tasks.

Goals for this Guide
====================

After following this guide, you will be able to:

-   Demonstrate a minimal Makefile-based solution for a *very* simple
    LED-blinking firmware.

-   Understand the basic concepts of MCU development.

-   Perform build/test/debug cylces entirely from the CLI on Linux (and
    eventually Mac)

-   Adapt the Makefile to a continuous integration system such as
    Jenkins. In other words, it should be straightforward to automate
    building and publishing firmware binary release-candidates
    automatically following code review

-   Avoid copying vendor code with non-free licenses. Some vendors
    provide code examples or supporting source files with non-free
    licenses. Instead of copying example code from these vendors, we
    will reference datasheets and manuals.

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
========

Development Boards
------------------

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

The datasheet for your microcontroller is often the best source of
information about how to program your MCU. Find your vendor’s datasheet
on their website and put it someplace handy. You will be using the
datasheet a lot!

Things we need from the Vendor Datasheets:

-   ROM (flash) size

-   ROM base address

-   RAM size

-   RAM base address

-   GPIO Bank and Pin for blinking LED

-   GPIO configuration and/or control registers

In order to enable the GPIOs as outputs and blink an LED, we have to
find the addresses of the control registers from the vendor datasheets.
We also need to know which GPIO bank (and/or pin) is mapped to an
existing LED on the dev board (hopefully there is one).

-   Nuvoton

    -   MCU: NUC029SEE

    -   MCU Datasheet: Nuvoton NUC029xEE technical user manual
        (TRM\_NUC029xEE\_EN\_Rev1.01.pdf)

        -   Note: For this model, the 'S' in the model designates the
            physical package type. This datasheet is shared across a few
            different package types.

    -   SDK Datasheet: NuMicro Family NuTiny-SDK-NUC029SEE User Manual
        (UM\_NuTiny-SDK-NUC029SEE\_EN\_Rev1.00.pdf)

    -   SVD File: NUC029EE\_v1.svd (from Keil pack downloads, see link
        below)

    -   ROM size: 128K

    -   ROM base address: 0x0000\_0000

    -   RAM size: 16K

    -   RAM base address: 0x2000\_0000

    -   LED GPIO: GPIO1 (from "SDK Circuit Schematic" in SDK User
        Manual). Acccording to "Target Chip Schematic", LED is hooked up
        to GPIO Bank B (PB.4), Pin 10

    -   LED PIN Bit Offset: 4 (i.e. PB.4 is enabled using the fifth bit
        in the register, GPIOB\_DOUT)

    -   See "Section 6.2.4 System Memory Map", "6.2.7 Register Map",
        "6.6.5 Register Map", "SDK Circuit Schematic"

    -   System Control Register: GPB\_MFP, Offset:
        GCR\_BA(0x5000\_0000)+0x34 "GPIOA Multiple Function and Input
        Type Control Register"

    -   0x5000\_4000-0x5000\_7FFF: "GPIO Control registers"

    -   GPIO\_BA (base address): 0x5000\_4000

    -   GPIOB\_PMD (I/O mode control register): GPIO\_BA+0x040

    -   GPIOB\_DOUT (output register): GPIO\_BA+0x048

-   ST

    -   ST STM32F407xx: look in "Memory mapping" (Section 4), "Table 10.
        register boundary addresses"

    -   0x4002\_0C00-0x4002\_0FFF: GPIOD

    -   TODO: exact register addresses of the GPIO bank we want to
        enable for use.

Software
========

Getting Started
===============

    x@x1carbon:~$ cd ~/Code
    x@x1carbon:~/Code$ mkdir arm-blink

Project Source File Overview
============================

The following source files are used to build the binary you will load:

-   The device startup ARM assembly source (startup\_ARMCMX.s)

-   The device memory parameters (heap and stack size) (mem\_ARMCM0.h)

-   The device application C source (main.c)

Walking through the ARM Startup Assembly Language File
======================================================

We’ll start by copying the the ARM assembly startup file we need from
the official ARM software github.

    x@x1carbon:~/Code$ git clone git@github.com:ARM-software/CMSIS_5.git
    x@x1carbon:~/Code$ cd CMSIS_5/CMSIS
    x@x1carbon:~/Code/CMSIS_5/CMSIS$ find | grep "startup" | grep CM0 | grep GCC
    ./DSP/Platforms/FVP/ARMCM0/Startup/GCC/startup_ARMCM0.S
    ./DSP/Platforms/IPSS/ARMCM0/Startup/GCC/startup_ARMCM0.S
    x@x1carbon:~/Code/CMSIS_5/CMSIS$ cp ./DSP/Platforms/FVP/ARMCM0/Startup/GCC/startup_ARMCM0.S ~/Code/arm-blink/

What is going on in this file? First go read the first five paragraphs
from the [fine
manual](https://sourceware.org/binutils/docs/as/Secs-Background.html#Secs-Background)
for binutils as (the GNU binutils assembler). The manual explains what a
binary section is and will help you understand how the linker works, so
don’t skip it!

The first two lines of startup\_ARMCM0.S set the ASM syntax and
architecture (the Cortex-M0 is an armv6-m).

The Interrupt Vector Table
--------------------------

-   The next lines of the setup assembly define a binary section called
    ".vectors" with a two byte alignment. This section is commonly
    called the [interrupt vector
    table](https://en.wikipedia.org/wiki/Interrupt_vector_table).

-   The interrupt vector table is essentially an array of function
    pointers.

-   In the assembly code, three
    [global](https://sourceware.org/binutils/docs/as/Global.html#Global)
    symbols are declared. These symbols help the linker find the vector
    table when it assembles the final binary that you will flash to your
    device.

-   Next, the vector table itself is defined. The [ARM Cortex-M0 vector
    table](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0497a/BABIFJFG.html)
    layout is specified by ARM.

-   When an interrupt occurs the CPU jumps to the 32-bit address for the
    specific interrupt that occurred and continues executing code there.

-   The interrupt we care about right now is the Reset interrupt that
    occurs when the CPU powers on.

-   The first 32-bits in the vector table are special: they hold the
    initial stack pointer, the address of the top of the stack. (note:
    stacks grow down on ARM and nearly all other modern processors).

-   The next 32-bits point at the address of the reset handler code
    (which will be defined later in the assembly file).

-   A bunch more default handlers are created for different interrupts
    that we reload-firefox

-   Next, the "BL" instruction tells the CPU to branch to the SystemInit
    function, when the SystemInit function returns it will continue on
    the next instruction. This function will be written in C code later
    and linked using the link script.

-   After we return from SystemInit, we pick up by loading two addresses
    using two [ARM-specific "synthetic"
    opcodes](https://sourceware.org/binutils/docs/as/ARM-Opcodes.html#ARM-Opcodes).
    These lines reference two symbols, `_copy_table_start_` and
    `_copy_table_end_`. These symbols are used by ResetHandler to copy
    the data sections of the binary from ROM to RAM. We’ll see them
    being defined later in the linker script.

-   A similar process happens with `_zero_table_start_` and
    `_zero_table_end_` in order to zero out the [BSS
    section](https://en.wikipedia.org/wiki/.bss).

The C Code
==========

The Linker Script
=================

> The main purpose of the linker script is to describe how the sections
> in the input files should be mapped into the output file, and to
> control the memory layout of the output file.
>
> —  [GNU LD
> Manual](https://sourceware.org/binutils/docs/ld/Scripts.html)

The linker script instructs GNU ld to create a binary that includes the
vector table section, compiled assembly instructions section, and
compiled C program sections. All these sections need to go into the
exact right locations in the binary. This way the CPU can find the
vector table where it expects it to be, the vector table’s second entry
points at the compiled ResetHandler code, and so on.

We will just the copy linker script from the ARM CMSIS v5 distribution
since it has an open license:

    x@x1carbon:~/Code/arm-blink$ cp /home/x/Code/CMSIS_5/CMSIS/DSP/Platforms/IPSS/ARMCM0/LinkScripts/GCC/lnk.ld .

The linker script references a file called mem\_ARMCM0.h which defines
the stack size as 12 KB and a heap size of 1024 KB (1 MB).

    x@x1carbon:~/Code/arm-blink$ cp /home/x/Code/CMSIS_5/CMSIS/DSP/Platforms/IPSS/ARMCM0/LinkScripts/GCC/mem_ARMCM0.h .

Next, edit the linker script to make the size value parameters match
your MCU from the information you collected above. Make sure to convert
decimal sizes to hex!

For example, for the NUC029SEE has 128KB ROM and 16KB RAM, so you would
set the values as follows.

-   Set \_\_ROM\_\_SIZE to "0x000020000" (128Kb\*1024 is 131072 bytes in
    decimal, 0x20000 in hex)

-   Set \_\_RAM\_\_SIZE to "0x000004000" (16Kb\*1024 is 16384 bytes in
    decimal, 0x4000 in hex)

-   The \_\_ROM\_BASE and \_\_RAM\_BASE do not need to be changed since
    they are standard values.

The linker script defines the memory layout using the `MEMORY` command.
This command allows later parts of the linker script to reference
specific regions of memory. Our memory consists of two regions: `FLASH`
and `RAM`, which are defined according to the size/base parameters you
setup.

Next, the linker script declares that that ResetHandler function
(defined in the startup assembly file) should be the main [entry
point](https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_node/ld_24.html)
for our final binary.

The script then uses the `SECTIONS` keyword to define the binary
sections:

-   The main `.text` section is defined in the `FLASH` memory region. It
    includes the following susubsections:

    -   The .vectors section, which references the vector table defined
        in the startup assembly file.

    -   All input program binary .text sections follow next. In our case
        the C code will be compiled into a binary object with a single
        text section.

    -   The code for any initializers, finalizers, constructors, and
        destructors (i.e. for C libraries or C++ applications)

    -   Read-only data (rodata)

    -   A special section called the
        [eh-frame](https://www.airs.com/blog/archives/460) is used by
        GCC to handle C++ exceptions and unwind the stack when
        debugging.

-   The `.ARM.extab` and `.ARM.exidx` sections are also used for
    exceptions and stack unwinding, but are specifically part of the ARM
    standard.

-   The `.copy.table` section is a special section that is used by the
    ARM startup assembly code. This section will contain the memory
    addresses of the program data section (i.e. the part that would
    contain global variables or structures).

-   The `.zero.table` section is similar to the `.copy.table` sections.
    The memory regions referenced by the symbols in this section will be
    zeroed out in the ARM startup assembly.

-   The `.data` section is the first binary section in the `MEMORY`
    region. It includes the following subsections:

    -   the `data_start` symbol marks the start of this section; it is
        referenced earlier in the linker script and in startup assembly
        fiile.

    -   the vtable ([a virtual method
        table](https://en.wikipedia.org/wiki/Virtual_method_table)) used
        by C++ programs. \*\*

    -   Next, the linker includes the main data section and all other
        data sections from any input binary files.

    -   Data values for preinit, init, finit come next. These are also
        used for C++ programs.

Building OpenOCD
================

-   TODO: Walkthrough install of ARM GCC toolchain

<!-- -->

    export PATH=$PATH:/home/x/Toolchains/gcc-arm-none-eabi-9-2019-q4-major/bin

-   TODO: Walkthrough build/install OpenOCD

Resources
=========

-   [Cortex-M0
    Boot](https://jcastellssala.com/2016/12/15/cortex-m0-boot/) nice
    article describing how the Cortex-M0 boots

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

-   [A Deep Dive into ARM Cortex-M Debug
    Interfaces](https://interrupt.memfault.com/blog/a-deep-dive-into-arm-cortex-m-debug-interfaces)
    in-depth guide to how Cortex-M debugging works

-   [Nuvoton Board Support
    Packages](https://www.nuvoton.com/tool-and-software/software-development-tool/bsp/)
    Links to various downloads (including github links) for many
    different Nuvoton MCUs, including the NUC029.

-   [GNU LD Command
    language](https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_chapter/ld_3.html)
    Understanding GNU LD linker scripts.

-   [From Zero to main(): Demystifying Firmware Linker
    Scripts](https://interrupt.memfault.com/blog/how-to-write-linker-scripts-for-firmware)
    How linker scripts work, illustrated by a simple blinky hello world.

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
