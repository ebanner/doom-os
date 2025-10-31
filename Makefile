debug: os.img
	qemu-system-i386 -S -s -monitor stdio os.img

memory_map: memory_map.bin
	qemu-system-i386 -monitor stdio memory_map.bin

boot_sector_asm.o: boot_sector.asm
	nasm -f elf32 -g -F dwarf boot_sector.asm -o boot_sector_asm.o

boot_sector_c.o: boot_sector.c
	i686-elf-gcc \
		-m32 \
		-ffreestanding \
		-fno-pic \
		-fno-stack-protector \
		-nostdlib \
		-O2 \
		-g \
		-c boot_sector.c \
		-o boot_sector_c.o

os.elf: boot_sector_asm.o boot_sector_c.o
	i686-elf-ld \
		-m elf_i386 \
		-T link.ld \
		-o os.elf \
		boot_sector_asm.o boot_sector_c.o

os.bin: os.elf
	i686-elf-objcopy -O binary os.elf os.bin

os.img: os.bin
	truncate -s 510 os.img
	dd if=os.bin of=os.img conv=notrunc 2>/dev/null
	printf '\x55\xAA' >> os.img

docker:
	# docker build -t doom-os .
	docker run -it --rm -v $(CURDIR):/src doom-os

clean:
	rm -f *.o *.elf *.bin *.img
