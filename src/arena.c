#include "arena.h"
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static void *arena_alloc_aligned(arena_t *a, size_t size, size_t align);
static void *arena_resize_aligned(arena_t *a, void *old_memory, size_t old_size, size_t new_size, size_t align);
static uintptr_t align_forward(uintptr_t ptr, size_t align);
static bool is_power_of_two(uintptr_t p);

void arena_init(arena_t *a, void *backing_buf, size_t backing_buf_len)
{
    a->buf = (uint8_t *)backing_buf;
    a->buf_len = backing_buf_len;
    a->cur_offset = 0;
    a->prev_offset = 0;
}

void *arena_alloc(arena_t *a, size_t size)
{
    return arena_alloc_aligned(a, size, DEFAULT_ALIGNMENT);
}

void *arena_resize(arena_t *a, void *old_memory, size_t old_size, size_t new_size)
{
    return arena_resize_aligned(a, old_memory, old_size, new_size, DEFAULT_ALIGNMENT);
}

void arena_free_all(arena_t *a)
{
    a->cur_offset = 0;
    a->prev_offset = 0;
}

// -------------------------------------------------------------------------------------------------

static void *arena_alloc_aligned(arena_t *a, size_t size, size_t align)
{
    // Align cur_offset to the specified alignment
    uintptr_t cur_ptr = (uintptr_t)a->buf + (uintptr_t)a->cur_offset;
    uintptr_t offset = align_forward(cur_ptr, align);
    offset -= (uintptr_t)a->buf;

    // Is there memory left in the backing array
    if (offset + size > a->buf_len) {
        fprintf(stderr, "Out of memory :(\n");
        return NULL;
    }

    void *ptr = &a->buf[offset];
    a->prev_offset = offset;
    a->cur_offset = offset + size;

    memset(ptr, 0, size);

    return ptr;
}

static void *arena_resize_aligned(arena_t *a, void *old_memory, size_t old_size, size_t new_size, size_t align)
{
    uint8_t *old_mem = (uint8_t *)old_memory;

    assert(is_power_of_two(align));

    // If this is actually a new allocation
    if (old_mem == NULL || old_size == 0) {
        return arena_alloc_aligned(a, new_size, align);
    }

    if (a->buf <= old_mem && old_mem < a->buf + a->buf_len) {
        if (a->buf + a->prev_offset == old_mem) {
            a->cur_offset = a->prev_offset + new_size;
            if (new_size > old_size) {
                memset(&a->buf[a->cur_offset], 0, new_size - old_size);
            }

            return old_memory;
        }

        void *new_memory = arena_alloc_aligned(a, new_size, align);
        size_t copy_size = old_size < new_size ? old_size : new_size;
        memmove(new_memory, old_memory, copy_size);

        return new_memory;
    }

    fprintf(stderr, "Memory is out of bounds of the arena\n");

    return NULL;
}

static uintptr_t align_forward(uintptr_t ptr, size_t align)
{
    uintptr_t p, a, modulo;

    assert(is_power_of_two(align));

    p = ptr;
    a = (uintptr_t)align;
    // The same as (p % a) but faster here with a being a power of two
    modulo = p & (a - 1);

    if (modulo != 0) {
        // If p is not aligned, make it so
        p += a - modulo;
    }

    return p;
}

static bool is_power_of_two(uintptr_t p)
{
    return (p & (p - 1)) == 0;
}
