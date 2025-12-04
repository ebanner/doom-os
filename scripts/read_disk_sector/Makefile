run: boot.bin
	qemu-system-i386 -monitor stdio boot.bin

boot.bin:
	nasm -f bin boot_sector.asm -o boot.bin

clean:
	rm -f boot.*
