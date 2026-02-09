#include "inttypes.h"

typedef long long int64_t;

int abs(int j);

/* GCC helper functions for 64-bit arithmetic on 32-bit systems */
int64_t __divdi3(int64_t a, int64_t b);
uint64_t __udivdi3(uint64_t a, uint64_t b);
uint64_t __umoddi3(uint64_t a, uint64_t b);
