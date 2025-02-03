#include "arena.h"
#include <stdlib.h>

int main(void)
{
    uint8_t backing_buf[256];
    arena_t a = {0};
    arena_init(&a, backing_buf, 256);

    void *backing_buf2 = malloc(256);
    arena_t a2 = {0};
    arena_init(&a2, backing_buf2, 256);

    arena_free_all(&a2);
    arena_free_all(&a);

    return 0;
}
