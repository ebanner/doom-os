#include "stdlib.h"
#include "inttypes.h"

/* Forward declarations */
uint64_t __udivdi3(uint64_t a, uint64_t b);
uint64_t __umoddi3(uint64_t a, uint64_t b);

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

    if (b == 0)
        return 0; /* FIXME: trigger software interrupt */
    else if (b == a)
        return 1;
    else if (b > a)
        return 0;
    else if (b_high == 0)
        return a / b_low;
    
    /* For other cases, use a simple binary long division algorithm */
    /* This avoids recursion by using 32-bit operations */
    uint64_t quotient = 0;
    uint64_t remainder = 0;
    
    /* Break into 32-bit halves for manual division */
    uint32_t a_high = (uint32_t)(a >> 32);
    uint32_t a_low = (uint32_t)a;
    
    /* Full 64-bit division using binary search / bit shifting */
    /* Shift divisor left until it's just less than dividend */
    int shift = 0;
    uint64_t temp_b = b;
    while (temp_b <= a && temp_b != 0) {
        temp_b <<= 1;
        shift++;
    }
    if (shift > 0) {
        shift--;
        temp_b >>= 1;
    }
    
    /* Now do long division */
    remainder = a;
    for (int i = shift; i >= 0; i--) {
        if (remainder >= (b << i)) {
            remainder -= (b << i);
            quotient |= (1ULL << i);
        }
    }
    
    return quotient;
}

/* GCC helper function for 64-bit unsigned modulo on 32-bit systems */
uint64_t __umoddi3(uint64_t a, uint64_t b)
{
    /* Handle modulo by zero */
    if (b == 0) {
        return 0; /* Undefined behavior, but avoid crash */
    }
    
    /* Simple case: if divisor is larger than dividend, result is dividend */
    if (b > a) {
        return a;
    }
    
    /* Simple case: if they're equal, result is 0 */
    if (b == a) {
        return 0;
    }
    
    /* Break into 32-bit halves */
    uint32_t a_high = (uint32_t)(a >> 32);
    uint32_t a_low = (uint32_t)a;
    uint32_t b_high = (uint32_t)(b >> 32);
    uint32_t b_low = (uint32_t)b;
    
    /* If divisor fits in 32 bits, use simpler algorithm */
    if (b_high == 0) {
        /* Divisor is 32-bit - compute modulo using 32-bit operations */
        /* a % b = ((a_high % b) << 32 | a_low) % b */
        uint32_t high_mod = a_high % b_low;  /* 32-bit % 32-bit is native */
        /* Now compute: (high_mod * 2^32 + a_low) % b_low */
        /* Using identity: (x * 2^32 + y) % b = ((x * (2^32 % b)) + y) % b */
        /* But 2^32 % b_low might be large, so let's use division */
        uint64_t combined = ((uint64_t)high_mod << 32) | a_low;
        /* Use identity: a % b = a - (a / b) * b */
        uint64_t quotient = combined / b_low;
        return combined - quotient * b_low;
    }
    
    /* For 64-bit divisor, use the identity: a % b = a - (a / b) * b */
    uint64_t quotient = a / b;
    return a - quotient * b;
}

