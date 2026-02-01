#include <inttypes.h>

#include <stdlib.h>


typedef _Bool bool;


void assert(bool result) {
    if (! result) {
        __asm__ __volatile__ (
            "movl $0xDEADBEEF, %%eax"
            :
            :
            : "eax", "memory"
        );

        __asm__ __volatile__ ("hlt");
    }
}

void test_64_32_division() {
    uint64_t a = 5;
    uint64_t b = 2;
    
    uint64_t c = a / b;

    assert(c == 2);
}


void test_64_64_division() {
    uint64_t a = 0x0000000200000000ULL;
    uint64_t b = 0x0000000100000000ULL;
    
    uint64_t c = a / b;

    assert(c == 2);
}



int main() {
    test_64_32_division();
    test_64_64_division();

    __asm__ __volatile__ (
        "movl $0x600DCAFE, %%eax"
        :
        :
        : "eax", "memory"
    );

    __asm__ __volatile__ ("hlt");

}

