## Compiler Flags

Required compiler flags:

- ~~-`-sda=all`~~
- `-no_callt`
- `-single_tda`
- `-preprocess_assembly_files`

## Register Usage

| Register | Alternate Name | Usage Type    |
|----------|----------------|---------------|
| r0       |                | Zero/Fixed    |
| r1       |                | Temporary     |
| r2       |                | Temporary     |
| r3       | sp             | Stack Pointer |
| r4       | gp             | Fixed         |
| r5       | tp             | Fixed         |
| r6–r19   |                | Temporary     |
| r20–r29  |                | Permanent     |
| r30      | ep             | Permanent     |
| r31      | lp             | Link Pointer  |

### Register Types

- **Temporary**: Caller-save registers (value may change after function calls)
- **Permanent**: Callee-save registers (value preserved after function calls)

Due to the complex memory model of RH850 and the flexibility of setting flags in GHS compiler, users need to ensure that register usage remains consistent with the above table.

Users can use `gdump` [C:\ghs\comp_202115\gdump.exe] to disassemble ELF files and check the usage of special registers.
```bash
gdump -ytext build/firmware.elf > firmware.elf.txt
```
