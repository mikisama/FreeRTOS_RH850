/*===========================================================================*/
/* Module       = dr7f701013.ld                                              */
/* Version      = V1.50                                                      */
/*                extracted from device file dr7f701013.dvf                  */
/*                by DeFiXRH850 1.0.2.0                                      */
/*===========================================================================*/
/*                                  COPYRIGHT                                */
/*===========================================================================*/
/* Copyright (c) 2018 by Renesas Electronics Europe GmbH,                    */
/*               a company of the Renesas Electronics Corporation            */
/*===========================================================================*/
/* Purpose:     Template of linker directive file                            */
/*                                                                           */
/*===========================================================================*/
/*                                                                           */
/* Warranty Disclaimer                                                       */
/*                                                                           */
/* Because the Product(s) is licensed free of charge, there is no warranty   */
/* of any kind whatsoever and expressly disclaimed and excluded by Renesas,  */
/* either expressed or implied, including but not limited to those for       */
/* non-infringement of intellectual property, merchantability and/or         */
/* fitness for the particular purpose.                                       */
/* Renesas shall not have any obligation to maintain, service or provide bug */
/* fixes for the supplied Product(s) and/or the Application.                 */
/*                                                                           */
/* Each User is solely responsible for determining the appropriateness of    */
/* using the Product(s) and assumes all risks associated with its exercise   */
/* of rights under this Agreement, including, but not limited to the risks   */
/* and costs of program errors, compliance with applicable laws, damage to   */
/* or loss of data, programs or equipment, and unavailability or             */
/* interruption of operations.                                               */
/*                                                                           */
/* Limitation of Liability                                                   */
/*                                                                           */
/* In no event shall Renesas be liable to the User for any incidental,       */
/* consequential, indirect, or punitive damage (including but not limited    */
/* to lost profits) regardless of whether such liability is based on breach  */
/* of contract, tort, strict liability, breach of warranties, failure of     */
/* essential purpose or otherwise and even if advised of the possibility of  */
/* such damages. Renesas shall not be liable for any services or products    */
/* provided by third party vendors, developers or consultants identified or  */
/* referred to the User by Renesas in connection with the Product(s) and/or  */
/* the Application.                                                          */
/*                                                                           */
/*===========================================================================*/
/* Environment:                                                              */
/*              Device:         R7F701013xAFP                                */
/*              IDE:            GHS Multi for V800  V6.xx or later           */
/*===========================================================================*/

CONSTANTS
{
  zero_start = 0xffff8000
}

MEMORY
 {
  iROM_0         : ORIGIN = 0x00000000,  LENGTH = 512k
  iROM_1         : ORIGIN = 0x01000000,  LENGTH = 32k
  iRAM_0         : ORIGIN = 0xFEDF8000,  LENGTH = 32k
  iRAM_R         : ORIGIN = 0xFEE00000,  LENGTH = 32k
 }

SECTIONS
 {

/* Start of internal ROM area (iROM_0) */

  .intvect                              :>iROM_0 /* start of interrupt vector */
//   .intvect_end  0x0550                  :>.      /* end   of interrupt vector */
  .intvect_end  0x0200                  :>.      /* end   of interrupt vector */
  .rozdata                              :>.      /* constant datas in ZDA area */
  .robase   align(4)                    :>.      /* initialize textpointer TP for SDA addressing */
  .rosdata  align(4)                    :>.      /* constant datas in SDA area */
  .rodata   align(4)                    :>.      /* constant datas in normal area */

  .text     align(4)                    :>.      /* program code area */

  .fixaddr  align(4)                    :>.      /* ghs internal (compiler) */
  .fixtype  align(4)                    :>.      /* ghs internal (compiler) */
  .secinfo  align(4)                    :>.      /* ghs internal (runtime library) */
  .syscall  align(4)                    :>.      /* ghs internal (linker) */

  .romdata  ROM(.data)                  :>.      /* constant data to initialize variables (copied to RAM at startup)*/
  .romzdata ROM(.zdata)                 :>.      /* constant data to initialize variables in ZDA area (copied to RAM at startup)*/
  .romsdata ROM(.sdata)                 :>.      /* constant data to initialize variables in SDA area (copied to RAM at startup)*/
  .romtdata ROM(.tdata)                 :>.      /* constant data to initialize variables in TDA area (copied to RAM at startup)*/
  .romsldata ROM(.sldata)               :>.      /* constant data to initialize variables in LSDA area (copied to GRAM at startup)*/
/* Start of internal User-Boot-ROM1 area (iROM_1) */

  .bcode    align(4)                     :>iROM_1 /* user defined segment for executable code located in user boot 1 area */
  .bconst   align(4)                     :>.      /* user defined segment for constant data located in user boot 1 area   */
/* Start of internal RAM area (iRAM) */

  .data                                 :>iRAM_0    /* initialized data */
  .sldata    align(4)                   :>.         /* user defined segment for initialized data */
  .slbss     align(4)                   :>.         /* user defined segment for initialized data */
  .bss       align(4)                   :>.         /* zero initialized data*/

  .sda_start align(4)                   :>.         /* initialize globalpointer GP for SDA addressing */
  .sdata     align(4)                   :>.         /* initialized data in SDA area*/
  .sbss      align(4)                   :>.         /* zero initialized data in SDA area*/
  .sda_end   align(4)                   :>.         /* end of SDA addressing */
  .zdata     align(4)                   :>.         /* initialized data in ZDA area*/
  .zbss      align(4)                   :>.         /* zero initialized data in ZDA area*/

  .tdata     align(4) MAX_SIZE(0x0100)  :>.         /* initialized and zero-initialized data in TDA area */
  .stack     align(4) pad(0x0800)       :>.         /* definition of stack size */
  .heapbase  align(4)                   :>.
  .heap      align(4)
  	        pad(endaddr(iRAM_0)-addr(.heapbase))
  	        NOCLEAR	                    :>.         /* definition of heap size */
/* Start of internal retention RAM area (iRAM_R) */

  .rdata    align(4)                    :>iRAM_R     /* user defined segment for for initialized data located in retention RAM  */
  .rbss     align(4)                    :>.          /* user defined segment for zero initialized data located in retention RAM */
/*  Symbols for compiler references */

  ___ghs_romstart   = MEMADDR(iROM_0);
  ___ghs_romend     = MEMENDADDR(iROM_0);

  ___ghs_ramstart   = MEMADDR(iRAM_0);
  ___ghs_ramend     = MEMENDADDR(iRAM_0);

  ___ghs_rramstart  = MEMADDR(iRAM_R);
  ___ghs_rramend    = MEMENDADDR(iRAM_R);

 }

/*===========================================================================*/
/*      End of File                                                          */
/*===========================================================================*/
