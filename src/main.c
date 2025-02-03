#include "arena.h"
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    uint8_t backing_buf[256];
    arena_t a = {0};
    arena_init(&a, backing_buf, 256);

    int *nums = arena_alloc(&a, 10 * sizeof(int));
    if (!nums) {
        fprintf(stderr, "Memory allocation erorr\n");
        return 1;
    }

    for (size_t i = 0; i < 10; ++i) {
        nums[i] = i * i;
        printf("%d ", nums[i]);
    }
    printf("\n");

    arena_free_all(&a);

    void *backing_buf2 = malloc(256);
    arena_t a2 = {0};
    arena_init(&a2, backing_buf2, 256);

    arena_free_all(&a2);

    return 0;
}
