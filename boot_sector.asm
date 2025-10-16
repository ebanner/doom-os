[org 0x7C00]

[bits 16]
main:
    cli

    ; --- Enter protected mode ---
    lgdt [gdt_ptr]
    mov eax, cr0
    or  eax, 1              ; PE=1
    mov cr0, eax
    jmp CODE_SEGMENT_SELECTOR_INDEX:protected_mode_entry       ; far JMP

[bits 32]
protected_mode_entry:
    mov ax, DATA_SEGMENT_SELECTOR_INDEX       ; set segments in PM
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

jmp $

; main:
;     call kmain


; ---------------- GDT ----------------

CODE_SEGMENT_SELECTOR_INDEX equ (1 << 3)        ; 0x08
DATA_SEGMENT_SELECTOR_INDEX equ (2 << 3)        ; 0x10

gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF            ; code: base=0, limit=4GB, D=1, G=1
    dq 0x00CF92000000FFFF            ; data: base=0, limit=4GB, D=1, G=1
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

