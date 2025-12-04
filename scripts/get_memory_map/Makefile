debug: memory_map.bin
	qemu-system-i386 \
		-S \
		-gdb tcp::1234 \
		-monitor stdio \
		memory_map.bin

memory_map.o: get_memory_map.asm
	nasm -f elf32 -g -F dwarf -o memory_map.o get_memory_map.asm

memory_map.elf: memory_map.o
	i686-elf-ld -m elf_i386 -Ttext 0x7C00 -o memory_map.elf memory_map.o

memory_map.bin: memory_map.elf
	i686-elf-objcopy -O binary memory_map.elf memory_map.bin

clean:
	rm -f memory_map.o memory_map.elf memory_map.bin
