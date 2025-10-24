// kernel.c — minimal freestanding kernel

// This will be the entry point - no function wrapper needed
void main(void) {
    volatile int x = 0xDEADBEEF;
    
    // This branch will be taken - set eax to 0xDEADBEEF
    __asm__ volatile ("movl $0xDEADBEEF, %eax");
    
    // Nothing fancy, just hang forever
    // You can inspect eax register here to verify the jump worked
    for (;;) { }
}
