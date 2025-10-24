CC = i686-elf-gcc
AS = nasm

CFLAGS = -m32 -ffreestanding -fno-pic -fno-stack-protector -nostdlib -O2
ASFLAGS = -f elf32

run: os.img
	qemu-system-i386 -nographic os.img

debug: os.img
	qemu-system-i386 -monitor stdio os.img

all: os.img

boot_sector.o: boot_sector.asm
	$(AS) $(ASFLAGS) boot_sector.asm -o boot_sector.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

os.elf: boot_sector.o kernel.o
	i686-elf-ld -m elf_i386 -T link.ld -o os.elf boot_sector.o kernel.o

os.bin: os.elf
	i686-elf-objcopy -O binary os.elf os.bin

os.img: os.bin
	truncate -s 510 os.img
	dd if=os.bin of=os.img conv=notrunc 2>/dev/null
	printf '\x55\xAA' >> os.img
	ls -l os.img
	@echo "Built os.img"

clean:
	rm -f *.o *.elf *.bin *.img
