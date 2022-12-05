.PHONY: all clean

PLATFORM			?= PLATFORM_WEB

PROJECT_NAME			?= index
PROJECT_VERSION			?= 1.0
PROJECT_BUILD_PATH		?= .

RAYLIB_PATH			?= ../raylib

RAYLIB_INCLUDE_PATH		?= $(RAYLIB_PATH)/src
RAYLIB_LIB_PATH			?= $(RAYLIB_PATH)/src

RAYLIB_LIBTYPE			?= STATIC

BUILD_MODE			?= DEBUG

USE_WAYLAND_DISPLAY		?= FALSE

BUILD_WEB_ASYNCIFY		?= FALSE
BUILD_WEB_SHELL			?= src/minshell.html
BUILD_WEB_HEAP_SIZE		?= 134217728
BUILD_WEB_RESOURCES		?= TRUE
BUILD_WEB_RESOURCES_PATH	?= resources

RAYLIB_RELEASE_PATH		?= $(RAYLIB_PATH)/src

ifeq ($(PLATFORM),PLATFORM_WEB)
	EMSDK_PATH			?= ../emsdk
	EMSCRIPTEN_PATH		?= $(EMSDK_PATH)/upstream/emscripten
	CLANG_PATH			= $(EMSDK_PATH)/upstream/bin
	NODE_PATH			= $(EMSDK_PATH)/node/bin
	export PATH			= $(EMSDK_PATH);$(EMSCRIPTEN_PATH);$(CLANG_PATH);$(NODE_PATH);$(PYTHON_PATH):$$(PATH)
	export EMSDK_PYTHON	= $(EMSDK_PATH)/python/3.9.2_64bit/bin/python3.9
endif

ifeq ($(PLATFORM),PLATFORM_WEB)
	CC 			= $(EMSCRIPTEN_PATH)/emcc
endif

MAKE 				?= make

RM				= rm

CFLAGS 				= -std=c99 -Wall -Wno-missing-braces -Wunused-result -D_DEFAULT_SOURCE

ifeq ($(BUILD_MODE),DEBUG)
	CFLAGS += -g -D_DEBUG
else
	ifeq ($(PLATFORM),PLATFORM_WEB)
		ifeq ($(BUILD_WEB_ASYNCIFY),TRUE)
			CFLAGS += -O3
		else
			CFLAGS += -Os
		endif

		CFLAGS += -sLEGACY_RUNTIME
	else
		CFLAGS += -s -O2
	endif
endif

INCLUDE_PATHS = -I. -I$(RAYLIB_PATH)/src -I$(RAYLIB_PATH)/src/external -I$(RAYLIB_PATH)/src/extras

LDFLAGS = -L. -L$(RAYLIB_RELEASE_PATH) -L$(RAYLIB_PATH)/src

ifeq ($(PLATFORM),PLATFORM_WEB)
	LDFLAGS += -s USE_GLFW=3 -s TOTAL_MEMORY=$(BUILD_WEB_HEAP_SIZE) -s FORCE_FILESYSTEM=1

	ifeq ($(BUILD_WEB_ASYNCIFY),TRUE)
			LDFLAGS += -s ASYNCIFY
	endif

	ifeq ($(BUILD_WEB_RESOURCES),TRUE)
			LDFLAGS += --preload-file $(BUILD_WEB_RESOURCES_PATH)
	endif

	ifeq ($(BUILD_MODE),DEBUG)
		LDFLAGS += -s ASSERTIONS=1 --profiling
	endif

	LDFLAGS += --shell-file $(BUILD_WEB_SHELL)
	EXT = .html
endif

ifeq ($(PLATFORM),PLATFORM_WEB)
	LDLIBS = $(RAYLIB_RELEASE_PATH)/libraylib.a
endif

PROJECT_SOURCE_DIR ?= src

PROJECT_SOURCE_FILES ?= \
	main.c

OBJS = $(patsubst %.c, %.o, $(PROJECT_SOURCE_DIR)/$(PROJECT_SOURCE_FILES))

INDEX_PAGE_NAME = index

OUT_DIR = out

all: $(PROJECT_NAME)

$(PROJECT_NAME): $(OBJS)
	$(CC) -o $(OUT_DIR)/$(INDEX_PAGE_NAME)$(EXT) $(OBJS) $(CFLAGS) $(INCLUDE_PATHS) $(LDFLAGS) $(LDLIBS) -D$(PLATFORM)

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(INCLUDE_PATHS) -D$(PLATFORM)

clean:
	$(RM) $(OUT_DIR)/index.html $(OUT_DIR)/index.wasm $(OUT_DIR)/index.js $(OUT_DIR)/index.data $(OBJS)