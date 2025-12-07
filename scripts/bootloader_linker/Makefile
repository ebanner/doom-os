boot_sector.img: boot_sector.elf
	i686-elf-objcopy -O binary boot_sector.elf boot_sector.img

boot_sector.elf: boot_sector_asm.o boot_sector_c.o
	i686-elf-ld \
		-m elf_i386 \
		-T link.ld \
		-o boot_sector.elf \
		boot_sector_asm.o \
		boot_sector_c.o

boot_sector_asm.o: boot_sector.asm
	nasm -f elf32 -g -F dwarf boot_sector.asm -o boot_sector_asm.o

boot_sector_c.o: boot_sector.c
	i686-elf-gcc \
		-m32 \
		-ffreestanding \
		-fno-pic \
		-fno-stack-protector \
		-nostdlib \
		-O0 \
		-g \
		-c boot_sector.c \
		-o boot_sector_c.o

clean:
	rm -f boot_sector.o boot_sector.elf boot_sector.img

