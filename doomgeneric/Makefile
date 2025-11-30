# Default target
all: main m_random.o

# Compile object file
m_random.o: m_random.c m_random.h doomtype.h
	gcc -Wall \
		-Wextra \
		-std=c99 \
		-ffreestanding \
		-nostdlib \
		-nostdinc \
		-I. \
		-fno-builtin \
		-c m_random.c \
		-o m_random.o

# Compile main object file
main.o: main.c m_random.h doomtype.h
	gcc -Wall \
		-Wextra \
		-std=c99 \
		-ffreestanding \
		-nostdlib \
		-nostdinc \
		-I. \
		-fno-builtin \
		-c main.c \
		-o main.o

# Link executable
main: main.o m_random.o
	gcc -Wall \
		-Wextra \
		-std=c99 \
		-ffreestanding \
		-nostdlib \
		-nostdinc \
		-I. \
		-fno-builtin \
		main.o \
		m_random.o \
		-o main

# Clean build artifacts
clean:
	rm -f *.o main

.PHONY: all clean

