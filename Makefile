CC := clang
DBG_BIN := lldb
CFLAGS += -std=c99
CFLAGS += -Wall
CFLAGS += -Wextra
CFLAGS += -pedantic
# CFLAGS += -Werror
CFLAGS += -Wmissing-declarations
ASANFLAGS=-fsanitize=address -fno-common -fno-omit-frame-pointer
CFLAGS += 
LDFLAGS := 
LIBS := 
SRC_FILES := $(wildcard ./src/*.c)
BIN_DIR := ./bin
BIN := $(BIN_DIR)/arena

ifeq ($(shell uname -s), Linux)
else
	BIN = $(BIN_DIR)/arena.exe
endif

build: bin-dir
	$(CC) $(CFLAGS) $(LIBS) $(SRC_FILES) -o $(BIN) $(LDFLAGS)

build-asan: bin-dir
	LSAN_OPTIONS=verbosity=1:log_threads=1 $(CC) $(ASANFLAGS) $(CFLAGS) $(LIBS) $(SRC_FILES) -o $(BIN) $(LDFLAGS)

debug-build: bin-dir
	$(CC) -g $(CFLAGS) $(LIBS) $(SRC_FILES) -o $(BIN) $(LDFLAGS)

run: build
	$(BIN) $(ARGS)

run-asan: build-asan
	$(BIN) $(ARGS)

debug: debug-build
	$(DBG_BIN) $(BIN) $(ARGS)

bin-dir:
	@mkdir -p $(BIN_DIR)

clean:
	rm -rf $(BIN_DIR)/*

gen-compilation-db:
	bear -- make build
