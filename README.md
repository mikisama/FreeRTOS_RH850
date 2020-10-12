# FreeRTOS Ported to RH850

This provides a very basic port of FreeRTOS to RH850.

## Requirement

1. [GCC](https://gcc-renesas.com/v850/v850-download-toolchains/)
2. [CMake](https://github.com/Kitware/CMake)
3. [Ninja](https://github.com/ninja-build/ninja)

## How to Build

modify the `V850_GCC_DIR` variable in `CMakeLists.txt`

```bash
$ cd build
$ cmake -G 'Ninja' ../
$ ninja
```
