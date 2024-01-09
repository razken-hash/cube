#include <stdio.h>
#include <stdlib.h>

int main()
{

    int a = 15;

    if (a % 3 == 0)
    {
        printf("a is not divisible by 3\n");
    }
    else if (a % 5 == 0)
    {
        printf("a is divisible by 5\n");
    }
    else
    {
        printf("a is divisible by 3 and 5\n");
    }

    return 0;
}