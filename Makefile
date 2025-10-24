CC = i686-elf-gcc
AS = nasm

CFLAGS = -m32 -ffreestanding -fno-pic -fno-stack-protector -nostdlib -O2
ASFLAGS = -f elf32

run: boot.img
	qemu-system-i386 -nographic boot.img

debug: boot.img
	qemu-system-i386 -monitor stdio boot.img

all: boot.img

boot_sector.o: boot_sector.asm
	$(AS) $(ASFLAGS) boot_sector.asm -o boot_sector.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

boot.elf: boot_sector.o kernel.o
	i686-elf-ld -m elf_i386 -T link.ld -o boot.elf boot_sector.o kernel.o

boot.bin: boot.elf
	i686-elf-objcopy -O binary boot.elf boot.bin

boot.img: boot.bin
	truncate -s 510 boot.img
	dd if=boot.bin of=boot.img conv=notrunc 2>/dev/null
	printf '\x55\xAA' >> boot.img
	ls -l boot.img
	@echo "Built boot.img"

clean:
	rm -f boot_sector.o kernel.o boot.elf boot.bin boot.img
