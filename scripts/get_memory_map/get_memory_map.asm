; get_memory_map_once.asm — one-shot E820 (first entry only)
BITS 16

_start:
first:
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

second:
    ; ---- Second E820 call ----
    xor bx, bx
    add di, cx

    mov eax, 0xE820
    mov edx, 0x534D4150
    mov ecx, 24
    ; EBX already has continuation from first call
    int 0x15

third:
    ; ---- Third E820 call ----
    add di, cx

    mov eax, 0xE820
    mov edx, 0x534D4150
    mov ecx, 24
    ; EBX already has continuation from first call
    int 0x15

forth:
    ; ---- Forth E820 call ----
    add di, cx

    mov eax, 0xE820
    mov edx, 0x534D4150
    mov ecx, 24
    ; EBX already has continuation from first call
    int 0x15

fifth:
    ; ---- Fifth E820 call ----
    add di, cx

    mov eax, 0xE820
    mov edx, 0x534D4150
    mov ecx, 24
    ; EBX already has continuation from first call
    int 0x15

sixth:
    ; ---- Sixth E820 call ----
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
; (qemu) x/gx 0x00090000 + 8
; 00090008: 0x000000000009fc00
; (qemu) x/wx 0x00090000 + 8 + 8
; 00090010: 0x0000000000000001
;
; ## Second section
;
; (qemu) x/gx 0x00090000 + 20
; 00090014: 0x000000000009fc00
; (qemu) x/gx 0x00090000 + 20 + 8
; 0009001C: 0x0000000000000400
; (qemu) x/wx 0x00090000 + 20 + 8 + 8
; 00090024: 0x00000002
;
; ## Third section
;
; (qemu) x/gx 0x00090000 + 40
; 00090028: 0x00000000000f0000
; (qemu) x/gx 0x00090000 + 40 + 8
; 00090030: 0x0000000000010000
; (qemu) x/gx 0x00090000 + 40 + 8 + 8
; 00090038: 0x0000000000000002
;
; ## Forth section
;
; (qemu) x/gx 0x00090000 + 60
; 0009003c: 0x0000000000100000
; (qemu) x/gx 0x00090000 + 60 + 8
; 00090044: 0x0000000007ee0000
; (qemu) x/gx 0x00090000 + 60 + 8 + 8
; 0009004c: 0x0000000000000001
;
; ## Fifth section
;
; (qemu) x/gx 0x00090000 + 80
; 00090050: 0x0000000007fe0000
; (qemu) x/gx 0x00090000 + 80 + 8
; 00090058: 0x0000000000020000
; (qemu) x/gx 0x00090000 + 80 + 8 + 8
; 00090060: 0x0000000000000002
;
; ## Sixth section
;
; (qemu) x/gx 0x00090000 + 100
; 00090064: 0x00000000fffc0000
; (qemu) x/gx 0x00090000 + 100 + 8
; 0009006c: 0x0000000000040000
; (qemu) x/gx 0x00090000 + 100 + 8 + 8
; 00090074: 0x0000000000000002
;
