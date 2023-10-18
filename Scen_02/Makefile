# Thanks to Job Vranish (https://spin.atomicobject.com/2016/08/26/makefile-c-projects/)

# Plantform compiler tools
CC = $(PREFIX)gcc
AR = $(PREFIX)ar
STRIP = $(PREFIX)strip

TARGET_EXECUTABLE_FILE := ExecutableFile
TARGET_STATIC_LIB := StaticLib.a
TARGET_SHARE_LIB := ShareLib.so

BUILD_DIR := ./build
SRC_DIRS := ./src

# Find all the C and C++ files we want to compile
# Note the single quotes around the * expressions. The shell will incorrectly expand these otherwise, but we want to send the * directly to the find command.
SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.c' -or -name '*.s')

# Prepends BUILD_DIR and appends .o to every src file
# As an example, ./your_dir/hello.cpp turns into ./build/./your_dir/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# String substitution (suffix version without %).
# As an example, ./build/hello.cpp.o turns into ./build/hello.cpp.d
DEPS := $(OBJS:.o=.d)

# Every folder in ./src will need to be passed to GCC so that it can find header files
INC_DIRS := $(shell find $(SRC_DIRS) -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate a .d file next to the .o file for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP

.PHONY:executable_file static_lib share_lib clean help print

executable_file: $(BUILD_DIR)/$(TARGET_EXECUTABLE_FILE)

static_lib: $(BUILD_DIR)/$(TARGET_STATIC_LIB)

share_lib: $(BUILD_DIR)/$(TARGET_SHARE_LIB)

# The executable file build step.
$(BUILD_DIR)/$(TARGET_EXECUTABLE_FILE): $(OBJS)
	$(CXX) $(OBJS) -o $@ $(LDFLAGS)

# The static lib build step.
$(BUILD_DIR)/$(TARGET_STATIC_LIB): $(OBJS)
	$(AR) rcs $@ $^

# The static lib build step.
$(BUILD_DIR)/$(TARGET_SHARE_LIB): $(OBJS)
	$(CXX) -shared -fPIC -o $@ $^

# Build step for C source
$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Build step for C++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

clean:
	rm -r $(BUILD_DIR)

print:
	@echo SRCS [$(SRCS)]
	@echo OBJS [$(OBJS)]
	@echo DEPS [$(DEPS)]
	@echo INC_DIRS [$(INC_DIRS)]
	@echo CPPFLAGS [$(CPPFLAGS)]

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)