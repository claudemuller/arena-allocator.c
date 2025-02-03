# Arena Allocator

An arena/linear memory allocator built in C.

# Requirements

- [clang](https://clang.llvm.org/)
- [make](https://www.gnu.org/software/make/)

# Build

```bash
make build

# Build with AddressSanitizer (ASAN)
make build-asan

# Build a debug binary
make build-debug
```

# Run

```bash
make run

# Run with AddressSanitizer (ASAN)
make run-asan
```

# Debugging with `lldb`

```bash
make debug
```

