[org 0x7C00]

[bits 16]
main:
    jmp $                   ; spin forever

times 510-($-$$) db 0
dw 0xaa55               ; boot signature

