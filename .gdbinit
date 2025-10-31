# ---- connect + symbols -------------------------------------------------------
target remote :1234
symbol-file os.elf

# ---- start in protected mode (boot sector) ----------------------------------------
set architecture i386
set disassemble-next-line off
layout split
directory .

# ---- breakpoints -------------------------------------------------------
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

# ---- Show source and regs in a split pane --------------------------
define layout-src-regs
    tui enable
    layout src
    tui reg general
    winheight src 20
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
