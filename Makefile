debug: clean build/os.img | build
	qemu-system-i386 -S -s -monitor stdio build/os.img

run: build/os.img | build
	qemu-system-i386 -monitor stdio build/os.img

src/boot/boot_sector_asm.o: src/boot/boot_sector.asm
	nasm -f elf32 -g -F dwarf src/boot/boot_sector.asm -o src/boot/boot_sector_asm.o

src/boot/boot_sector_c.o: src/boot/boot_sector.c
	i686-elf-gcc \
		-m32 \
		-ffreestanding \
		-fno-pic \
		-fno-stack-protector \
		-nostdlib \
		-O0 \
		-g \
		-c src/boot/boot_sector.c \
		-o src/boot/boot_sector_c.o

DOOMGENERIC_SRC := $(wildcard src/doomgeneric/*.c)
DOOMGENERIC_OBJ := $(DOOMGENERIC_SRC:.c=.o)

$(info DOOMGENERIC_SRC = $(DOOMGENERIC_SRC))
$(info DOOMGENERIC_OBJ = $(DOOMGENERIC_OBJ))

src/doomgeneric/%.o: src/doomgeneric/%.c
	i686-elf-gcc \
		-m32 \
		-std=c99 \
		-ffreestanding \
		-fno-pic \
		-fno-stack-protector \
		-nostdlib \
        -nostdinc \
        -Isrc/libc \
        -fno-builtin \
		-O0 \
		-g \
		-c $< \
		-o $@

src/libc/stdlib.o: src/libc/stdlib.c src/libc/stdlib.h
	i686-elf-gcc \
		-m32 \
		-std=c99 \
		-ffreestanding \
		-fno-pic \
		-fno-stack-protector \
		-nostdlib \
		-nostdinc \
		-Isrc/libc \
		-fno-builtin \
		-O0 \
		-g \
		-c src/libc/stdlib.c \
		-o src/libc/stdlib.o

build/os.elf: src/boot/boot_sector_asm.o src/boot/boot_sector_c.o $(DOOMGENERIC_OBJ) src/libc/stdlib.o | build
	i686-elf-ld \
		-m elf_i386 \
		-T link.ld \
		-o build/os.elf \
		src/boot/boot_sector_asm.o src/boot/boot_sector_c.o \
		$(DOOMGENERIC_OBJ) \
		src/libc/stdlib.o

build/os.img: build/os.elf | build
	i686-elf-objcopy -O binary build/os.elf build/os.img

build:
	mkdir -p $@

docker:
	# docker build -t doom-os .
	docker run -it --rm -v $(CURDIR):/src doom-os

clean:
	rm -rf build/ *.o *.elf *.bin *.img doomgeneric/*.o libc/*.o boot/*.o
