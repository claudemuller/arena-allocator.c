#ifndef ARENA_H_
#define ARENA_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifndef DEFAULT_ALIGNMENT
#define DEFAULT_ALIGNMENT (2 * sizeof(void *))
#endif

typedef struct {
    uint8_t *buf;
    size_t buf_len;
    size_t prev_offset;
    size_t cur_offset;
} arena_t;

void arena_init(arena_t *a, void *backing_buf, size_t backing_buf_len);
void *arena_alloc(arena_t *a, size_t size);
void *arena_resize(arena_t *a, void *old_memory, size_t old_size, size_t new_size);
void arena_free_all(arena_t *a);

#endif // !ARENA_H_
