## $(Game Title)

![$(Game Title)](screenshots/screenshot000.png "$(Game Title)")

### Description

$(Your Game Description)

### Features

 - $(Game Feature 01)
 - $(Game Feature 02)
 - $(Game Feature 03)

### Controls

Keyboard:
 - $(Game Control 01)
 - $(Game Control 02)
 - $(Game Control 03)

### Screenshots

_TODO: Show your game to the world, animated GIFs recommended!._

### Developers

 - Pedro Victor - Programmer/Artist
 - $(Developer 02) - $(Role/Tasks Developed)
 - $(Developer 03) - $(Role/Tasks Developed)

### Links

 - YouTube Gameplay: $(YouTube Link)
 - itch.io Release: $(itch.io Game Page)
 - Steam Release: $(Steam Game Page)

### How to build (on Linux for Web)

1) Install [git](https://git-scm.com/)

2) Install raylib and web build dependencies:

```git clone "https://github.com/raysan5/raylib.git" raylib
git clone "https://github.com/emscripten-core/emsdk.git" emsdk
cd emsdk
./emsdk install latest
cd ..
```

3) Generate the Emscripten config file

```cd emsdk
upstream/emscripten/emcc --generate-config
```

4) Adjust the Emscripten config file paths to your environment

- Get the full path of the current working directory:

```pwd
```

- Copy the output to the clipboard (usually, you can do this from the terminal by selecting with mouse + Ctrl+Alt+C)

- Open upstream/emscripten/.emscripten on a text editor

- Change LLVM_ROOT to the current directory (clipboard) + "/upstream/bin" (PS: REMEMBER THE SINGLE QUOTES!)

- Change BINARYEN_ROOT to the current directory (clipboard) + "/upstream" (PS: REMEMBER THE SINGLE QUOTES!)

- Change NODE_PATH to the full path of Emscripten's internal Node.js runtime (replace NODE_VERSION with the actual name of the folder) (current directory from clipboard + "/NODE_VERSION/bin/node") (PS: REMEMBER THE SINGLE QUOTES!)

- Comment out (add "# ") before JAVA

- Save and close the file

5) Build Raylib for web

- Go to Raylib's source directory

```cd ../raylib/src
```

- Open Makefile on a text editor

- Change PLATFORM to PLATFORM_WEB

- Change the "Emscripten required variables" block to the following (change the Python version if needed):

```ifeq ($(PLATFORM),PLATFORM_WEB)
	EMSDK_PATH		?= ../../emsdk
	EMSCRIPTEN_PATH		?= $(EMSDK_PATH)/upstream/emscripten
	CLANG_PATH		= $(EMSDK_PATH)/upstream/bin
	NODE_PATH		= $(EMSDK_PATH)/node/bin
	export PATH		= $(EMSDK_PATH);$(EMSCRIPTEN_PATH);$(CLANG_PATH);$(NODE_PATH);$(PYTHON_PATH):$$(PATH)
	export EMSDK_PYTHON	= $(EMSDK_PATH)/python/3.9.2_64bit/bin/python3.9
endif
```

- Change CC in the block "HTML5 emscripten compiler" from "emcc" to "$(EMSCRIPTEN_PATH)/emcc" (without the quotes)

- On the line bellow, change AR from "emar" to "$(EMSCRIPTEN_PATH)/emar" (without the quotes)

- Save and close the file

- Type "make" on the terminal and see how it goes

7) Clone this repository and try to build the game:

$(Clone and build)

8) Test using a local back-end:

```python -m http.server 8080 --directory ../out
```

PS: If "make clean" doesn't work, change "RM" in the game's Makefile to Windows' rm

### License

This game sources are licensed under the MIT license. Check [LICENSE](LICENSE) for further details.

*Copyright (c) 2022 Pedro Victor @pedrocga1
