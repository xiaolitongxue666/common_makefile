#---------------------------------------------------------
# Define compilation platform commands
#---------------------------------------------------------
CC 			= $(PREFIX)gcc
AR 			= $(PREFIX)ar
STRIP 		= $(PREFIX)strip

CP 			= cp
RM 			= rm -f
MAKE 		= make
ECHO 		= echo
MKDIR 		= mkdir
RMDIR 		= rmdir

ifeq (,$(filter objs,$(notdir $(shell pwd))))
#---------------------------------------------------------
# First create an intermediate directory (obj) in the current directory 
# and enter the directory to compile, 
# so that all process files will be generated in the 'objs' directory.
#---------------------------------------------------------

MK_ROOT	:= $(shell pwd)
BUILD_DIR := $(MK_ROOT)/objs

export MK_ROOT

.PHONY:all clean help

all:
	$(MKDIR) -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*.*
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/makefile all

static_lib:
	$(MKDIR) -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*.*
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/makefile static_lib
	

share_lib:
	$(MKDIR) -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*.*
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/makefile share_lib


clean:
	rm -f $(BUILD_DIR)/*.*

help:
	@echo "Usage:"
	@echo "make all to compiler a exec file (Default)"
	@echo "make static_lib to compiler a static lib"
	@echo "make share_lib to compiler a share lib"

else
#---------------------------------------------------------
# Generate code (obj)
#---------------------------------------------------------
TARGET_EXECUTABLE_FILE	= ExecutableFile
TARGET_STATIC_LIB		= StaticLib.a
TARGET_SHARE_LIB		= ShareLib.so

INCLUDES	= -I $(MK_ROOT)
INCLUDES	+= -I $(MK_ROOT)/B_function
INCLUDES	+= -I $(MK_ROOT)/C_function

# Add you own lib header files
# INCLUDES	+= -I$(MK_ROOT)/../../../../../workspace/include
# INCLUDES	+= -I$(MK_ROOT)/../../../../../workspace/include_global

CFLAGS		=
CFLAGS		+=  -Wall
CFLAGS		+=  -g
#Use C99
#CFLAGS		+=  --std=gnu99

#CFLAGS		+=  -H

# Add you lib files
#LIBS		= -L $(MK_ROOT)/../workspace/lib
LDFlAGS		=

ARFLAGS		=
CXXFLAGS	=

#---------------------------------------------------------
# Input source code path
#---------------------------------------------------------
SRCDIR	= $(MK_ROOT)
SRCDIR	+= $(MK_ROOT)/B_function
SRCDIR	+= $(MK_ROOT)/C_function

#---------------------------------------------------------
# Add a virtual path (can be stored in each module with mk)
#---------------------------------------------------------
VPATH	+= $(SRCDIR)

#---------------------------------------------------------
# Generate OBJ
#---------------------------------------------------------
SRCS	= $(notdir $(foreach temp, $(SRCDIR), $(wildcard $(temp)/*.c)))
OBJS	= $(patsubst %.c, %.o, $(SRCS))

.PHONY:all

static_lib: $(TARGET_STATIC_LIB)

all: $(TARGET_EXECUTABLE_FILE)

$(TARGET_EXECUTABLE_FILE):$(OBJS)
	$(ECHO)
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
# EOF
