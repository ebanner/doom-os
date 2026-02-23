target remote :1234
symbol-file build/os.elf

layout split
directory .

break *0x7C00
tbreak main
continue
