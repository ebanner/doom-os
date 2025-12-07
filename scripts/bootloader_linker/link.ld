OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)

SECTIONS {
  . = 0x7C00;

  .text : {
    *(.text*)
  }

  .rodata : {
    *(.rodata*)
  }

  .data : {
    *(.data*)
  }

  .bss : {
    *(.bss*) *(COMMON)
  }

  /* Pad to 510 bytes and add boot signature */
  . = 0x7C00 + 510;
  
  .bootsig : {
    SHORT(0xAA55)
  }
}
