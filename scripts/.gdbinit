target remote :1234
set architecture i8086
break *0x7C00
c
layout asm
layout regs
set disassemble-next-line on

#
# Skip over int 0x15
#
# (gdb) tbreak *($cs*16 + $eip + 2)
#
