# ---- connect + symbols -------------------------------------------------------
target remote :1234
symbol-file os.elf

# ---- start in real mode (boot sector) ----------------------------------------
set architecture i8086
set disassembly-flavor intel
set disassemble-next-line on
layout asm
layout regs

break *0x7C00
tbreak main
continue

# ---- helpers -----------------------------------------------------------------
# Switch back to REAL MODE view (16-bit asm, step-by-step)
define rm
    set architecture i8086
    set disassemble-next-line on
    layout asm
    layout regs
end

# Switch to PROTECTED MODE / C SOURCE view (32-bit, DWARF line mapping)
define pm
    set architecture i386
    set disassemble-next-line off
    layout split
    directory .
    # If your DWARF paths are from another machine, uncomment and edit:
    # set substitute-path /old/build/root /current/source/root
end

# Skip over the next 2-byte INT instruction in real mode (your existing helper)
define skipint
    tbreak *($cs*16 + $eip + 2)
    continue
end

# If your kernel is loaded/relocated to a known runtime address, re-add symbols:
# usage:  (gdb) addsym 0x00100000
define addsym
    if $argc == 1
        add-symbol-file os.elf $arg0
    else
        echo "usage: addsym ADDRESS\n"
    end
end
