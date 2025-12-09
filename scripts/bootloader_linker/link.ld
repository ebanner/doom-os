OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)

SECTIONS {
  . = 0x7C00;

  .text : {
    boot_sector*.o(.text*)
  }

  .rodata : {
    boot_sector*.o(.rodata*)
  }

  .data : {
    boot_sector*.o(.data*)
  }

  .bss : {
    boot_sector*.o(.bss*) boot_sector*.o(COMMON)
  }

  /* Pad to 510 bytes and add boot signature */
  . = 0x7C00 + 510;
  
  .bootsig : {
    SHORT(0xAA55)
  }
}
