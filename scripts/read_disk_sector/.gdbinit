# ---- connect + symbols -------------------------------------------------------
file boot_sector.elf
target remote :1234

# ---- start in protected mode (boot sector) ----------------------------------------
set architecture i386
set disassemble-next-line off
layout split
directory .

# ---- breakpoints -------------------------------------------------------
break *0x7C00
tbreak my_bp
continue
