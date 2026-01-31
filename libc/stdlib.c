#include "stdlib.h"
#include "inttypes.h"

int abs(int j)
{
    return j < 0 ? -j : j;
}

/* GCC helper function for 64-bit signed division on 32-bit systems */
int64_t __divdi3(int64_t a, int64_t b)
{
    int neg = 0;
    uint64_t unsigned_a, unsigned_b, result;
    
    if (a < 0) {
        unsigned_a = (uint64_t)(-a);
        neg = 1;
    } else
        unsigned_a = (uint64_t)a;
    
    if (b < 0) {
        unsigned_b = (uint64_t)(-b);
        neg = !neg;
    } else
        unsigned_b = (uint64_t)b;
    
    result = unsigned_a / unsigned_b;
    
    if (neg)
        return -(int64_t)result;
    else
        return (int64_t)result;
}

/* GCC helper function for 64-bit unsigned division on 32-bit systems */
uint64_t __udivdi3(uint64_t a, uint64_t b)
{
    uint32_t b_low = (uint32_t)b;
    uint32_t b_high = (uint32_t)(b >> 32);
    uint32_t a_low = (uint32_t)a;
    uint32_t a_high = (uint32_t)(a >> 32);

    if (b == 0)
        /* FIXME: trigger software interrupt */
        return 0;
    else if (b == a)
        return 1;
    else if (b > a)
        return 0;
    else if (b_high == 0) {
        /* div EDX:EAX / b_low */
        uint32_t eax = a_low;
        uint32_t edx = a_high;
        __asm__ volatile (
            "divl %[divisor]"
            : "+d" (edx), "+a" (eax)
            : [divisor] "r" (b_low)
            : "cc"
        );
        uint64_t quotient = eax;
        return quotient;
    }
    
    int num_shift = 0;
    uint64_t shifted_b = b;
    while (shifted_b <= a && shifted_b != 0) {
        shifted_b <<= 1;
        num_shift++;
    }

    if (num_shift > 0) {
        num_shift--;
        shifted_b >>= 1;
    }

    uint64_t quotient = 0;
    uint64_t remainder = a;
    for (int i = num_shift; i >= 0; i--) {
        if (remainder >= shifted_b) {
            remainder -= shifted_b;
            quotient |= (1ULL << i);
        }
        shifted_b >>= 1;
    }
    
    return quotient;
}

/* GCC helper function for 64-bit unsigned modulo on 32-bit systems */
uint64_t __umoddi3(uint64_t a, uint64_t b)
{
    uint32_t b_low = (uint32_t)b;
    uint32_t b_high = (uint32_t)(b >> 32);
    uint32_t a_low = (uint32_t)a;
    uint32_t a_high = (uint32_t)(a >> 32);

    if (b == 0)
        return 0; /* FIXME: trigger software interrupt */
    else if (a == b)
        return 0;
    else if (a < b)
        return a;
    else if (b_high == 0) {
        uint32_t eax = a_low;
        uint32_t edx = a_high;
        __asm__ volatile (
            /* EDX:EAX / b_low */
            "divl %2" : "+d" (edx), "+a" (eax) : "r" (b_low)
            /* EDX ← remainder */
        );
        uint64_t remainder = edx;
        return (uint64_t)remainder;
    }
    else {
        /* For full 64/64 case, compute modulo using division */
        uint64_t quotient = __udivdi3(a, b);
        return a - quotient * b;
    }
}

