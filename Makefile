debug: os.img
	qemu-system-i386 -S -s -monitor stdio os.img

run: os.img
	qemu-system-i386 -monitor stdio os.img

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

DOOMGENERIC_SRC := $(wildcard doomgeneric/*.c)
DOOMGENERIC_OBJ := $(DOOMGENERIC_SRC:.c=.o)

$(info DOOMGENERIC_SRC = $(DOOMGENERIC_SRC))
$(info DOOMGENERIC_OBJ = $(DOOMGENERIC_OBJ))

doomgeneric/%.o: doomgeneric/%.c
	i686-elf-gcc \
		-m32 \
		-std=c99 \
		-ffreestanding \
		-fno-pic \
		-fno-stack-protector \
		-nostdlib \
        -nostdinc \
        -Ilibc \
        -fno-builtin \
		-O0 \
		-g \
		-c $< \
		-o $@

libc/stdlib.o: libc/stdlib.c libc/stdlib.h
	i686-elf-gcc \
		-m32 \
		-std=c99 \
		-ffreestanding \
		-fno-pic \
		-fno-stack-protector \
		-nostdlib \
		-nostdinc \
		-Ilibc \
		-fno-builtin \
		-O0 \
		-g \
		-c libc/stdlib.c \
		-o libc/stdlib.o

os.elf: boot_sector_asm.o boot_sector_c.o $(DOOMGENERIC_OBJ) libc/stdlib.o
	i686-elf-ld \
		-m elf_i386 \
		-T link.ld \
		-o os.elf \
		boot_sector_asm.o boot_sector_c.o \
		$(DOOMGENERIC_OBJ) \
		libc/stdlib.o

os.img: os.elf
	i686-elf-objcopy -O binary os.elf os.img

docker:
	# docker build -t doom-os .
	docker run -it --rm -v $(CURDIR):/src doom-os

clean:
	rm -f *.o *.elf *.bin *.img doomgeneric/*.o libc/*.o
