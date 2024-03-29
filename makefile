# GNU Make docs : https://www.gnu.org/software/make/manual/make.html
# Quick tutorial: https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/

CC        := gcc
LD        := gcc
AR        := ar
override CFLAGS := $(sort -Wall -Wextra $(CFLAGS))

MODULES := .
SRC_DIR := $(addprefix src/,$(MODULES))
SRC := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.c))
OBJ = $(patsubst %.c,build/release/%.o,$(SRC))
OBJ_D = $(patsubst %.c,build/debug/%.o,$(SRC))
BUILD_DIR = $(addprefix build/release/src/,$(MODULES))
BUILD_DIR_D = $(addprefix build/debug/src/,$(MODULES))
TEST_SRC := $(wildcard test/*.c)

INCLUDES := -I "./include"
LIBDIR   := -L "./lib/release/x86_64"
LIBDIR_D := -L "./lib/debug/x86_64"
# LIBS should be most ambiguous to least ambiguous
LIBS   :=
LIBS_D :=

LIBRARY   := lib/release/x86_64/CDebugHelper.lib
LIBRARY_D := lib/debug/x86_64/CDebugHelper-d.lib
EXECUTABLE   := 
EXECUTABLE_D := 
ifeq ($(OS), Windows_NT)
	EXECUTABLE   := build/release/main.exe
	EXECUTABLE_D := build/debug/main.exe
else
	EXECUTABLE   := build/release/main.out
	EXECUTABLE_D := build/debug/main.out
endif


#####[ Platform specific variables ]#####
DELETE      := 
RMDIR       := 
EXE         := 
HIDE_OUTPUT := 
PS          := 
ifeq ($(OS), Windows_NT)
	DELETE      := del /f
	RMDIR       := rmdir /s /q
	EXE         :=main.exe
	HIDE_OUTPUT := 2> nul
	PS          :=\\

else
	DELETE      := rm -f
	RMDIR       := rm -rf
	EXE         :=main.out
	HIDE_OUTPUT := > /dev/null
	PS          :=/
endif

#####[ recipes ]#####

$(BUILD_DIR):
ifeq ($(OS), Windows_NT)
	@IF not exist "$@" (mkdir "$@")
	@IF not exist lib (mkdir lib)
else
	@mkdir -p $@
	@mkdir -p lib
endif

$(BUILD_DIR_D):
ifeq ($(OS), Windows_NT)
	@IF not exist "$@" (mkdir "$@")
	@IF not exist lib (mkdir lib)
else
	@mkdir -p $@
	@mkdir -p lib
endif

# filtering and target patterns
# https://www.gnu.org/software/make/manual/make.html#Static-Usage
$(filter build/release/%.o,$(OBJ)): build/release/%.o: %.c
	@echo Building $<
	$(CC) $(CFLAGS) -c $< -o $@ $(INCLUDES) $(LIBDIR) $(LIBS)

$(filter build/debug/%.o,$(OBJ_D)): build/debug/%.o: %.c
	@echo Building $<
	$(CC) $(CFLAGS) -c $< -o $@ $(INCLUDES) $(LIBDIR_D) $(LIBS_D)


.PHONY: release debug release_executable debug_executable print clean
release:
	$(MAKE) release_executable CFLAGS="-DNDEBUG $(CFLAGS)"

debug:
	$(MAKE) debug_executable CFLAGS="-DDEBUG $(CFLAGS)"

release_executable: release_library
	$(LD) $(CFLAGS) $(TEST_SRC) -o $(EXECUTABLE) $(INCLUDES) -L . -l $(basename $(LIBRARY)) $(LIBDIR) $(LIBS)

release_library: $(BUILD_DIR) $(OBJ)
	$(AR) rcs $(LIBRARY) $(foreach obj,$(OBJ), -o $(obj)) 

debug_executable: debug_library
	$(LD) $(CFLAGS) $(TEST_SRC) -o $(EXECUTABLE_D) $(INCLUDES) -L . -l $(basename $(LIBRARY_D)) $(LIBDIR_D) $(LIBS_D)

debug_library: $(BUILD_DIR_D) $(OBJ_D)
	$(AR) rcs $(LIBRARY_D) $(foreach obj,$(OBJ_D), -o $(obj)) 

print:
	@echo $(SRC_DIR)
	@echo $(SRC)
	@echo $(OBJ)
	@echo $(OBJ_D)
	@echo $(BUILD_DIR)

clean:
ifeq ($(OS), Windows_NT)
	IF exist build (rmdir /s /q build)
	IF exist "$(LIBRARY)" ($(DELETE) "$(subst /,\,$(LIBRARY))")
	IF exist "$(LIBRARY_D)" ($(DELETE) "$(subst /,\,$(LIBRARY_D))")
else
	@rm -rf build
	@$(DELETE) $(LIBRARY)
	@$(DELETE) $(LIBRARY_D)
endif
	mkdir build
