run: build
	qemu-system-i386 -nographic boot_sect.bin

debug: build
	qemu-system-i386 -monitor stdio boot_sect.bin

build:
	nasm boot_sect.asm -f bin -o boot_sect.bin

kernel.elf: kernel.o
	ld.lld -m elf_i386 -nostdlib --image-base=0 -Ttext 0x8000 -e kmain -o kernel.elf kernel.o

kernel.o:
	clang \
		-target i386-elf \
		-m32 \
		-ffreestanding \
		-fno-builtin \
		-fno-stack-protector \
		-nostdlib \
		-c kernel.c \
		-o kernel.o

clean:
	rm -rf *.o *.elf
