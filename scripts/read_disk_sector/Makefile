run: boot_sector.bin
	qemu-system-i386 -S -s -monitor stdio boot_sector.bin

boot_sector.o: boot_sector.asm
	nasm -f elf32 -g -F dwarf boot_sector.asm -o boot_sector.o

boot_sector.elf: boot_sector.o
	i686-elf-ld \
		-m elf_i386 \
		-T link.ld \
		-o boot_sector.elf \
		boot_sector.o

boot_sector.bin: boot_sector.elf
	i686-elf-objcopy -O binary boot_sector.elf boot_sector.bin

clean:
	rm -f *.bin *.o *.elf

