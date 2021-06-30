#---------------------------------------------------------
# Define compilation platform commands
#---------------------------------------------------------
CC 			= $(PREFIX)gcc
#CC 			= $(PREFIX)gcc-9
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
# so that all process files will be generated in the current directory.
#---------------------------------------------------------

MK_ROOT	:= $(shell pwd)
BUILD_DIR := $(MK_ROOT)/objs

export MK_ROOT

.PHONY:help all clean
all:
	$(MKDIR) -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*.*
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/makefile all
	
executable_file:
	$(MKDIR) -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*.*
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/makefile executable_file

clean:
	rm -f $(BUILD_DIR)/*.*

else
#---------------------------------------------------------
# Generate code (obj)
#---------------------------------------------------------
TARGET		= TargetLib.a
TARGET_EXECULABLE_FILE	= ExecutableFile

INCLUDES	= -I $(MK_ROOT)
INCLUDES	+= -I $(MK_ROOT)/B_function
INCLUDES	+= -I $(MK_ROOT)/C_function

# Add you own lib header files
# INCLUDES	+= -I$(MK_ROOT)/../../../../../workspace/include
# INCLUDES	+= -I$(MK_ROOT)/../../../../../workspace/include_global

CFLAGS		=
CFLAGS		+=  -Wall
CFLAGS		+=  -g
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

all: $(TARGET)

executable_file: $(TARGET_EXECULABLE_FILE)

$(TARGET): $(OBJS)
	$(ECHO)
	$(ECHO) BUILD [$(TARGET)] USE [$(OBJS)]
	$(ECHO)
	$(ECHO) LIBS [$(LIBS)]
	$(ECHO)
	$(ECHO) INCLUDES [$(INCLUDES)]
	$(ECHO)
	$(ECHO) CFLAGS [$(CFLAGS)]
	$(ECHO)
	$(ECHO) LDFLAGS [$(LDFLAGS)]
	@echo Build Library $@ Use $(OBJS)
	$(AR) rcs $@ $^
	# Copy target lib file and it's header file to path you need 
	# @echo Copy $(TARGET) To $(EXPORT_LIB_DIR)
	# $(CP) $(TARGET) $(EXPORT_LIB_DIR)
	# @echo Copy $(MK_ROOT)/../../../../../platformlinux/linuxplatformlib/src/linuxplatform.h To $(EXPORT_INC_DIR)
	# $(CP) $(MK_ROOT)/../../../../../platformlinux/linuxplatformlib/src/linuxplatform.h $(EXPORT_INC_DIR)

$(TARGET_EXECULABLE_FILE):$(OBJS)
	$(ECHO)
	$(ECHO) BUILD [$(TARGET)] USE [$(OBJS)]
	$(ECHO)
	$(ECHO) LIBS [$(LIBS)]
	$(ECHO)
	$(ECHO) INCLUDES [$(INCLUDES)]
	$(ECHO)
	$(ECHO) CFLAGS [$(CFLAGS)]
	$(ECHO)
	$(ECHO) LDFLAGS [$(LDFLAGS)]
	@echo Build $@ Use $(OBJS)
	$(CC) $^ -o $@ $(LIBS) $(LDFLAGS)

<<<<<<< HEAD
#%o : %c
lib_api_or_main.o : lib_api_or_main.c
	@echo $@ Compiling $(notdir $<)...
=======
%.o : %.c
	@echo $@ Compiling $(notdir $<)... 
>>>>>>> bb3e12361fa46a0ebba41edd7f15a0662a5e75db
	$(CC) -c $(INCLUDES) $(CFLAGS) $< -o $@
	
endif
# EOF
