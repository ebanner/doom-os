; get_memory_map_once.asm — one-shot E820 (first entry only)
BITS 16
ORG 0x7C00

start:
    mov sp, 0x7C00

    ; Buffer for the entry: ES = 0x9000, DI = 0x0000
    mov ax, 0x9000
    mov es, ax
    xor di, di

    ; ---- E820 once ----
    xor ebx, ebx                ; continuation=0 (first call)
    mov eax, 0xE820             ; INT 15h, AX=E820h
    mov edx, 0x534D4150         ; 'SMAP'
    mov ecx, 24                 ; request 24 bytes (ACPI 3.0 layout)
    int 0x15

    ; ---- Second E820 call ----
    add di, cx

    mov eax, 0xE820
    mov edx, 0x534D4150
    mov ecx, 24
    ; EBX already has continuation from first call
    int 0x15

    jmp $

times 510-($-$$) db 0
dw 0xAA55

; # Usage
;
; This returns a list of memory map entries, each describing a region’s:
;
; - Base address (64-bit)
; - Length (64-bit)
; - Type (usable, reserved, ACPI reclaimable, etc.)
;
; | Type | Meaning          |
; |------|------------------|
; | 1    | Usable RAM       |
; | 2    | Reserved         |
; | 3    | ACPI reclaimable |
; | 4    | ACPI NVS         |
; | 5    | Bad memory       |
;
; ## First section
;
; (qemu) x/gx 0x00090000
; 00090000: 0x0000000000000000
; (qemu) x/gx 0x00090008
; 00090008: 0x000000000009fc00
; (qemu) x/wx  0x00090010
; 00090010: 0x0000000000000001
;
; ## Second section
;
; (qemu) x/gx 0x00090014
; 00090014: 0x000000000009fc00
; (qemu) x/gx 0x0009001C
; 0x0000000000000400
; (qemu) x/wx 0x00090024
;
