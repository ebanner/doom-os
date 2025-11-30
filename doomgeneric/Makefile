# Default target
all: main m_random.o

# Compile object file
m_random.o: m_random.c m_random.h doomtype.h
	gcc -Wall \
		-Wextra \
		-std=c99 \
		-c m_random.c \
		-o m_random.o

# Compile executable
main: main.c m_random.c m_random.h doomtype.h
	gcc -Wall \
		-Wextra \
		-std=c99 \
		main.c \
		m_random.c \
		-o main

# Clean build artifacts
clean:
	rm -f *.o main

.PHONY: all clean

