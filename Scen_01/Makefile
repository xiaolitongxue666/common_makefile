# Plantform compiler tools
CC = $(PREFIX)gcc
AR = $(PREFIX)ar
STRIP = $(PREFIX)strip

# Shell command
CP = cp
RM = rm -f
MAKE = make
ECHO = echo
MKDIR = mkdir
RMDIR = rmdir
UNAME := $(shell uname)

ifeq (,$(filter objs,$(notdir $(shell pwd)))) # if not in objs dir

MK_ROOT := $(PWD)
BUILD_DIR := $(MK_ROOT)/objs

export MK_ROOT

.PHONY:executable_file static_lib clean help debug

executable_file:
	$(MKDIR) -p $(BUILD_DIR)
	rm -rf $(BUILD_DIR)/*.*
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/Makefile executable_file

static_lib:
	$(MKDIR) -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*.*
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/Makefile static_lib
	

share_lib:
	$(MKDIR) -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*.*
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/Makefile share_lib


clean:
	rm -f $(BUILD_DIR)/*

help:
	@echo "Usage:"
	@echo "make executable_file to compiler a exec file (Default)"
	@echo "make static_lib to compiler a static lib"
	@echo "make share_lib to compiler a share lib"

debug:
	@echo CC is [$(CC)]
	@echo AR is [$(AR)]
	@echo STRIP is [$(STRIP)]
	@echo CP is [$(CP)]
	@echo RM is [$(RM)]
	@echo MAKE is [$(MAKE)]
	@echo ECHO is [$(ECHO)]
	@echo MKDIR is [$(MKDIR)]
	@echo RMDIR is [$(RMDIR)]
	@echo PWD v1 is [$(shell pwd)]
	@echo PWD v2 is [$(PWD)]
	@echo MK_ROOT is [$(MK_ROOT)]
	@echo BUILD_DIR is [$(BUILD_DIR)]
	
else # else in objs dir

# Global variables
TARGET_EXECUTABLE_FILE = ExecutableFile
TARGET_STATIC_LIB = StaticLib.a
TARGET_SHARE_LIB = ShareLib.so

INCLUDES = -I $(MK_ROOT)
INCLUDES += -I $(MK_ROOT)/B_function
INCLUDES += -I $(MK_ROOT)/C_function

# Add you own lib header files
# INCLUDES += -I$(MK_ROOT)/../../../../../workspace/include
# INCLUDES += -I$(MK_ROOT)/../../../../../workspace/include_global

CFLAGS =
CFLAGS +=  -Wall
CFLAGS +=  -g
#Use C99
#CFLAGS +=  --std=gnu99

#CFLAGS +=  -H

# Libs dirs
#LIBS = -L $(MK_ROOT)/../workspace/lib

# Libs flags
LDFlAGS =
LDFLAGS	+= -Wl,--start-group
#LDFLAGS += -lmxml
LDFLAGS	+= -Wl,--end-group

ARFLAGS =
CXXFLAGS =

# Input source code path
ifeq ($(MAKECMDGOALS), executable_file)
	SRCDIR = $(MK_ROOT)
else
	SRCDIR =
endif

ifeq ($(UNAME),Linux)
	$(ECHO) "Linux platform"
	CC=gcc
else ifeq ($(UNAME),macos)
	$(ECHO) "Macos platform"
	CC=gcc-11
else
	$(ECHO) "Windows platform"
	CC=gcc
endif

SRCDIR += $(MK_ROOT)/B_function
SRCDIR += $(MK_ROOT)/C_function

# Add a virtual path (can be stored in each module with mk)
VPATH += $(SRCDIR)

# Generate OBJ
SRCS = $(notdir $(foreach temp, $(SRCDIR), $(wildcard $(temp)/*.c)))
OBJS = $(patsubst %.c, %.o, $(SRCS))
OBJS2 = $(filter-out C_function.o,$(OBJS))

.PHONY:executable_file

static_lib: $(TARGET_STATIC_LIB)

executable_file: $(TARGET_EXECUTABLE_FILE)

$(TARGET_EXECUTABLE_FILE):$(OBJS)
	$(ECHO) make [$(MAKECMDGOALS)]
	$(ECHO) SRCDIR [$(SRCDIR)]
	$(ECHO) BUILD [$(TARGET_EXECUTABLE_FILE)] USE [$(OBJS)]
	$(ECHO)
	$(ECHO) LIBS [$(LIBS)]
	$(ECHO)
	$(ECHO) INCLUDES [$(INCLUDES)]
	$(ECHO)
	$(ECHO) CFLAGS [$(CFLAGS)]
	$(ECHO)
	$(ECHO) LDFLAGS [$(LDFLAGS)]
	@echo Build Executable File $@ Use $(OBJS)
	$(CC) $^ -o $@ $(LIBS) $(LDFLAGS)

$(TARGET_STATIC_LIB): $(OBJS)
	$(ECHO) make [$(MAKECMDGOALS)]
	$(ECHO) SRCDIR [$(SRCDIR)]
	$(ECHO) BUILD [$(TARGET_STATIC_LIB)] USE [$(OBJS)]
	$(ECHO)
	$(ECHO) LIBS [$(LIBS)]
	$(ECHO)
	$(ECHO) INCLUDES [$(INCLUDES)]
	$(ECHO)
	$(ECHO) CFLAGS [$(CFLAGS)]
	$(ECHO)
	$(ECHO) LDFLAGS [$(LDFLAGS)]
	@echo Build Static Library $@ Use $(OBJS)
	$(AR) rcs $@ $^
	# Copy target lib file and it's header file to path you need
	# @echo Copy $(TARGET_STATIC_LIB) To $(EXPORT_LIB_DIR)
	# $(CP) $(TARGET_STATIC_LIB) $(EXPORT_LIB_DIR)
	# @echo Copy $(MK_ROOT)/../../../../../platformlinux/linuxplatformlib/src/linuxplatform.h To $(EXPORT_INC_DIR)
	# $(CP) $(MK_ROOT)/../../../../../platformlinux/linuxplatformlib/src/linuxplatform.h $(EXPORT_INC_DIR)

$(TARGET_SHARE_LIB): $(OBJS)
	$(ECHO)
	$(ECHO) BUILD [$(TARGET_STATIC_LIB)] USE [$(OBJS)]
	$(ECHO)
	$(ECHO) LIBS [$(LIBS)]
	$(ECHO)
	$(ECHO) INCLUDES [$(INCLUDES)]
	$(ECHO)
	$(ECHO) CFLAGS [$(CFLAGS)]
	$(ECHO)
	$(ECHO) LDFLAGS [$(LDFLAGS)]
	@echo Build Share Library $@ Use $(OBJS)

-include *.d 
%.o : %.c 
	@echo $@ Compiling $(notdir $<)... 
	$(CC) -c -MMD $(INCLUDES) $(CFLAGS) $< -o $@
	

endif

#EOF




