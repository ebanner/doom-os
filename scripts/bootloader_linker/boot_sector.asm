; External function declarations

global _start, isr_handler
extern write_idt

[bits 16]
_start:
    ; Set up stack pointer
    mov esp, 0x7c00
    
    ; --- Enter protected mode ---
    cli

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
    
    ; Call the embedded C code
    call write_idt

    ; Load IDTR: limit = size-1, base = 0x10000
    lidt [idt_ptr]

    ; Mask PIC interrupts
    mov al, 0xFF
    out 0x21, al    ; tell master PIC: ignore IRQ0–7
    out 0xA1, al    ; tell slave PIC: ignore IRQ8–15

    ; Re-enable interrupts now that IDT is set up
    sti

    mov eax, 0xDEADBEEF

    jmp $

; ------------------------------------------------------------
; Tiny “do nothing safely” handler
; ------------------------------------------------------------
isr_handler:
    ; pusha

    ; TODO: put interrupt handling code here

    ; popa
    iretd

; ---------------- IDT ----------------

IDT_BASE       equ 0x10000
IDT_COUNT      equ 256
ISR_ENTRY_SIZE equ 8

idt_ptr:
    dw (IDT_COUNT*ISR_ENTRY_SIZE - 1) ; limit = 256*8-1 = 0x07FF
    dd IDT_BASE                       ; base
idt_end:


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
