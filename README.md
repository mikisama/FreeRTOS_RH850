# FreeRTOS Ported to RH850

This provides a very basic port of FreeRTOS to RH850.

## Requirement

1. [GCC](https://github.com/mikisama/Auto_Build_GCC_RH850/releases)
2. [CMake](https://github.com/Kitware/CMake/releases)
3. [Ninja](https://github.com/ninja-build/ninja/releases)

## How to Build

modify the `V850_GCC_DIR` variable in `CMakeLists.txt`

```bash
$ cmake -DCMAKE_TOOLCHAIN_FILE='cmake/gcc.cmake' -DCMAKE_BUILD_TYPE=Debug -Bbuild  -GNinja .
$ cmake --build build
```
