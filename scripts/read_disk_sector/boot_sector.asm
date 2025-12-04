[BITS 16]

main:
  xor ax, ax
  mov ds, ax
  mov es, ax

  mov ah, 0x02   ; BIOS function for reading from disk
  mov al, 1      ; Read 1 sector (512 byte chunk)
  mov ch, 0      ; Cylinder number (which 3D ring)
  mov cl, 2      ; Sector number (which slice of the pie [ring])
  mov dh, 0      ; Head number (which level of the 3D ring [depth])
  mov bx, 0x7e00 ; Buffer to store read data
  int 0x13       ; BIOS interrupt for disk operations


my_bp:
  jmp $


times 510-($-$$) db 0 ; Pad the rest of the boot sector with zeros
db 0x55, 0xaa         ; Boot signature


sector2:
    db "Hello from sector 2!", 0
