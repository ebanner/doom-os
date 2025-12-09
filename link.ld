OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)

SECTIONS {
  . = 0x7C00;

  .text : {
    boot_sector*(.text*)
  }

  .rodata : {
    boot_sector*(.rodata*)
  }

  .data : {
    boot_sector*(.data*)
  }

  .bss : {
    boot_sector*(.bss*) boot_sector*(COMMON)
  }

  /* Pad to 510 bytes and add boot signature */
  . = 0x7C00 + 510;
  
  .bootsig : {
    SHORT(0xAA55)
  }

  /* Include the rest of the object files after the boot signature */
  . = 0x7C00 + 512;
  
  .text.doomgeneric : {
    *(.text*)
  }

  .rodata.doomgeneric : {
    *(.rodata*)
  }

  .data.doomgeneric : {
    *(.data*)
  }

  .bss.doomgeneric : {
    *(.bss*) *(COMMON)
  }
}
