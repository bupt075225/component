// gcc -Wall -g testlib.c -o test -L./ -lfoo
// export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/data/git/component/build_linux_sw/src/usr/lib_demo

#include <stdio.h>
#include "foo.h"

int main(void)
{
    foo();
    return 0;
}
