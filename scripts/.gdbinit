target remote :1234
set architecture i8086
break *0x7C00
c
layout asm
layout regs
set disassemble-next-line on

define skipint
    tbreak *($cs*16 + $eip + 2)
    continue
end
