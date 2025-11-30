#include <stdio.h>
#include "m_random.h"

int main(void)
{
    int randno = M_Random();
    printf("Random number: %d\n", randno);
    
    return 0;
}

