run: os.img
	qemu-system-i386 -nographic os.img

debug: os.img
	qemu-system-i386 -monitor stdio os.img

boot_sector.bin:
	nasm boot_sector.asm -f bin -o boot_sector.bin

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

kernel.elf: kernel.o boot_sector.bin
	@BOOT_LEN=$$(wc -c < boot_sector.bin); \
	TEXT_ADDR=$$((0x7C00 + $$BOOT_LEN)); \
	ld.lld -m elf_i386 -nostdlib --image-base=0 -Ttext $$TEXT_ADDR -o $@ kernel.o

kernel.bin: kernel.elf
	llvm-objcopy -O binary -j .text kernel.elf kernel.bin

os.img: kernel.bin boot_sector.bin
	cat boot_sector.bin kernel.bin > os.img
	truncate -s 510 os.img
	printf '\x55\xAA' >> os.img

clean:
	rm -rf *.bin *.o *.elf os.img
