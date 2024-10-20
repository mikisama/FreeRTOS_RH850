# FreeRTOS Ported to RH850

This provides a very basic port of FreeRTOS to RH850.

Tested on the G3K single core chip (F1L).

## Advanced features

- Optimized task selection: Use the `SCH1L` instruction (similar to the `CLZ` instruction of ARM Cortex-M).
- Interrupt nesting is supported: Any interrupt with a higher priority can interrupt an interrupt handler running on a lower priority.
- Optimized interrupt processing: Only scratch registers are saved/restored upon ISR entry/exit unless preemption is necessary.
- Separate Interrupt Stack: RH850 does not support a separate hardware interrupt stack. This means that any interrupt might use any task stack depending on which context it is interrupting. Therefore, each task stack needs to be large enough to handle nested interrupts. Since assigning additional memory to each task stack would consume large amounts of RAM, we will use the system stack as the interrupt stack. Only the first level interrupt will use some amount of task stack

## Requirement

1. [GCC](https://github.com/mikisama/Auto_Build_GCC_RH850/releases) or [IAR](https://www.iar.com/products/architectures/renesas/iar-embedded-workbench-for-renesas-rh850) or [GHS](https://www.ghs.com/products/v850_development.html) or [CCRH](https://www.renesas.com/eu/en/software-tool/c-compiler-package-rh850-family)
2. [CMake](https://github.com/Kitware/CMake/releases)
3. [Ninja](https://github.com/ninja-build/ninja/releases)
4. [RFP](https://www.renesas.com/us/en/software-tool/renesas-flash-programmer-programming-gui)

## How to Build

<details>
<summary>Build with GCC</summary>

### Add toolchain path to the environment(PATH) variable.
```bash
$ # Set the PATH Environment Variables in Windows PowerShell
$ $env:path+=';D:/v850-elf-gcc-win32-x64/bin'
$ $env:path+=';C:/Program Files (x86)/Renesas Electronics/Programming Tools/Renesas Flash Programmer V3.08'
$ v850-elf-gcc --version
$ rfp-cli --version
```

### Build command
```bash
$ git clone https://github.com/mikisama/FreeRTOS_RH850
$ cd FreeRTOS_RH850/build
$ cmake -DCMAKE_TOOLCHAIN_FILE='cmake/gcc.cmake' -DCMAKE_BUILD_TYPE=Debug -GNinja ..
$ ninja
```
![build](docs/gcc_build.webp)
</details>

<details>
<summary>Build with IAR</summary>

### Add toolchain path to the environment(PATH) variable.
```bash
$ # Set the PATH Environment Variables in Windows PowerShell
$ $env:path+=';C:/Program Files (x86)/IAR Systems/Embedded Workbench 8.1/rh850/bin'
$ $env:path+=';C:/Program Files (x86)/Renesas Electronics/Programming Tools/Renesas Flash Programmer V3.08'
$ iccrh850 --version
$ rfp-cli --version
```

### Build command

```bash
$ git clone https://github.com/mikisama/FreeRTOS_RH850
$ cd FreeRTOS_RH850/build
$ cmake -DCMAKE_TOOLCHAIN_FILE='cmake/iar.cmake' -DCMAKE_BUILD_TYPE=Debug -GNinja ..
$ ninja
```
![build](docs/iar_build.webp)
</details>

<details>
<summary>Build with GHS</summary>

### Add toolchain path to the environment(PATH) variable.
```bash
$ # Set the PATH Environment Variables in Windows PowerShell
$ $env:path+=';C:/ghs/comp_201815'
$ $env:path+=';C:/Program Files (x86)/Renesas Electronics/Programming Tools/Renesas Flash Programmer V3.08'
$ ccrh850 --version dummy
$ rfp-cli --version
```

### Build command
```bash
$ git clone https://github.com/mikisama/FreeRTOS_RH850
$ cd FreeRTOS_RH850/build
$ cmake -DCMAKE_TOOLCHAIN_FILE='cmake/ghs.cmake' -DCMAKE_BUILD_TYPE=Debug -GNinja ..
$ ninja
```
![build](docs/ghs_build.webp)
</details>

<details>
<summary>Build with CCRH</summary>

### Add toolchain path to the environment(PATH) variable.
```bash
$ # Set the PATH Environment Variables in Windows PowerShell
$ $env:path+=';C:/Program Files (x86)/Renesas Electronics/CS+/CC/CC-RH/V2.04.00/bin'
$ $env:path+=';C:/Program Files (x86)/Renesas Electronics/Programming Tools/Renesas Flash Programmer V3.08'
$ ccrh -v
$ rfp-cli --version
```

### Build command

```bash
$ git clone https://github.com/mikisama/FreeRTOS_RH850
$ cd FreeRTOS_RH850/build
$ cmake -DCMAKE_TOOLCHAIN_FILE='cmake/ccrh.cmake' -DCMAKE_BUILD_TYPE=Debug -GNinja ..
$ ninja
```
![build](docs/ccrh_build.webp)
</details>

## [Documentation](https://github.com/mikisama/FreeRTOS_RH850/wiki)
