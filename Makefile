CC := clang
DBG_BIN := lldb
CFLAGS += -std=c99
CFLAGS += -Wall
CFLAGS += -Wextra
CFLAGS += -pedantic
# CFLAGS += -Werror
CFLAGS += -Wmissing-declarations
ASANFLAGS=-fsanitize=address -fno-common -fno-omit-frame-pointer
CFLAGS += $(shell pkg-config --cflags sdl2 SDL2_ttf SDL2_image)
LDFLAGS := -I/usr/lib/sdl2 -I/usr/lib/SDL2_ttf -I/usr/lib/SDL2_image -lSDL2 -lSDL2_image -lSDL2_ttf
# LDFLAGS := $(shell pkg-config --libs sdl2 SDL2_ttf SDL2_image)
LIBS := -I./lib -isystem ./lib
SRC_FILES := $(wildcard ./src/*.c)
BIN_DIR := ./bin
BIN := $(BIN_DIR)/guy

ifeq ($(shell uname -s), Linux)
	CFLAGS += -D_GNU_SOURCE
else
	BIN = $(BIN_DIR)/guy.exe
endif

build: bin-dir
	$(CC) $(CFLAGS) $(LIBS) $(SRC_FILES) -o $(BIN) $(LDFLAGS)

build-asan: bin-dir
	$(CC) $(ASANFLAGS) $(CFLAGS) $(LIBS) $(SRC_FILES) -o $(BIN) $(LDFLAGS)

bin-dir:
	@mkdir -p $(BIN_DIR)

debug: debug-build
	# LSAN_OPTIONS=verbosity=1:log_threads=1
	$(DBG_BIN) $(BIN) $(ARGS)

debug-build: bin-dir
	$(CC) -g $(CFLAGS) $(LIBS) $(SRC_FILES) -o $(BIN) $(LDFLAGS)

run-hud: build
	LD_PRELOAD=/usr/lib/mangohud/libMangoHud_dlsym.so mangohud $(BIN) $(ARGS)

run-asan: build-asan
	$(BIN) $(ARGS)

run: build
	$(BIN) $(ARGS)

clean:
	rm -rf $(BIN_DIR)/*

gen-compilation-db:
	bear -- make build
