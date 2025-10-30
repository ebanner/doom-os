memory_map: memory_map.bin
	qemu-system-i386 -monitor stdio memory_map.bin

memory_map.bin:
	nasm get_memory_map.asm -f bin -o memory_map.bin
