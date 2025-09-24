run: build
	qemu-system-i386 -nographic boot_sect.bin

debug: build
	qemu-system-i386 -monitor stdio boot_sect.bin

build:
	nasm boot_sect.asm -f bin -o boot_sect.bin

