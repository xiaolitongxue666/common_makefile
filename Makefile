#---------------------------------------------------------
# Define compilation platform commands
#---------------------------------------------------------
ifeq ($(PLF), arm)
PREFIX		= arm-linux-
PATH :=$(PATH):/usr/local/arm/3.3.2/bin
else ifeq ($(PLF), zynq)
PREFIX		= arm-xilinx-linux-gnueabi-
PATH :=$(PATH):/opt/xilinx_arm_sdk/bin
endif

CC 			= $(PREFIX)gcc
AR 			= $(PREFIX)ar
STRIP 		= $(PREFIX)strip

CP 			= cp
RM 			= rm -f
MAKE 		= make
ECHO 		= echo
MKDIR 		= mkdir
RMDIR 		= rmdir

ifeq (,$(filter objs,$(notdir $(CURDIR))))
#---------------------------------------------------------
# First create an intermediate directory (obj) in the current directory 
# and enter the directory to compile, 
# so that all process files will be generated in the current directory.
#---------------------------------------------------------

MK_ROOT	:= $(CURDIR)
BUILD_DIR := $(MK_ROOT)/objs
# EXPORT_LIB_DIR := $(MK_ROOT)/../../../../../workspace/lib
# EXPORT_INC_DIR := $(MK_ROOT)/../../../../../workspace/include

#export MK_ROOT EXPORT_INC_DIR EXPORT_LIB_DIR
export MK_ROOT

.PHONY:help all clean
all:
	$(MKDIR) -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*.*
	@echo PLF = $(PLF)
	+@$(MAKE) --quiet -C $(BUILD_DIR) -f $(MK_ROOT)/makefile all
	
executable_file:
	$(MKDIR) -p $(BUILD_DIR)bo(MK_ROOT)/makefile executable_file

clean:
	rm -f $(BUILD_DIR)/*.*

else
#---------------------------------------------------------
# Generate code (obj)
#---------------------------------------------------------
TARGET		= target_$(PLF).a
TARGET_EXECULABLE_FILE	= ExecutableFile


INCLUDES	= -I$(MK_ROOT) 
INCLUDES	+= -I$(MK_ROOT)/sub_1
INCLUDES	+= -I$(MK_ROOT)/sub_2

# Add you own lib header files
# INCLUDES	+= -I$(MK_ROOT)/../../../../../platformlinux/include  
# INCLUDES	+= -I$(MK_ROOT)/../../../../../workspace/include 
# INCLUDES	+= -I$(MK_ROOT)/../../../../../workspace/include_global

CFLAGS		=
#CFLAGS		+=  -Wall
#ifdef debug
#CFLAGS		+=  -g
#endif

CFLAGS		+=  -D$(PLF)

ifeq ($(PLF), x64)
CFLAGS		+=  -m64
endif

# Add you lib files
#LIBS		= -L $(MK_ROOT)/../workspace/lib
LDFlAGS		= 

ARFLAGS		=
CXXFLAGS	=

#---------------------------------------------------------
# Input source code path
#---------------------------------------------------------
SRCDIR	= $(MK_ROOT)
SRCDIR	+= $(MK_ROOT)/sub_1
SRCDIR	+= $(MK_ROOT)/sub_2

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
	@echo Build Library $@ Use $(OBJS)
	$(AR) rcs $@ $^
	# Copy target lib file and it's header file to path you need 
	# @echo Copy $(TARGET) To $(EXPORT_LIB_DIR)
	# $(CP) $(TARGET) $(EXPORT_LIB_DIR)
	# @echo Copy $(MK_ROOT)/../../../../../platformlinux/linuxplatformlib/src/linuxplatform.h To $(EXPORT_INC_DIR)
	# $(CP) $(MK_ROOT)/../../../../../platformlinux/linuxplatformlib/src/linuxplatform.h $(EXPORT_INC_DIR)

$(TARGET_EXECULABLE_FILE):$(OBJS)
	@echo Build $@ Use $(OBJS)
	$(CC) $^ -o $@ $(LIBS) -lrt

%o : %c
	@echo $@ Compiling $(notdir $<)... 
	$(CC) -c $(INCLUDES) $(CFLAGS) $< -o $@ 
	
endif
# EOF
