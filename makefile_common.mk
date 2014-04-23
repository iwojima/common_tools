
#########################################
############### MAKEFILE ################
# Author: iwojima
# primary version: 2013-8-7
# last version: 2013-12-26
# Usage: config variable DIR_WORK_ROOT to
#        match your system
#########################################

.PHONY:all clear rebuild global

MAKEDIR=$(shell pwd)
MAKE=make
Q=


ifneq "$(V)" "1"
	Q=@
endif

@?=

CC=gcc
CP=g++
AR=ar

COPY=cp
MV=mv
RM=rm -f

USER_NAME=$(shell whoami)


VPATH  =  /home/$(USER_NAME)/iWork/lib
VPATH  += /home/$(USER_NAME)/iWork/Thrid_party/ACE_wrappers_linux/lib

MAKE_CMD=
ISLIB=

DIR_WORK_ROOT=/home/$(USER_NAME)/iWork
DIR_SYS_INC=$(DIR_WORK_ROOT)/include
DIR_SYS_LIB=$(DIR_WORK_ROOT)/lib
DIR_INCLUDE_LOCAL=$(DIR_WORK_ROOT)/common
DIR_INCLUDE_DBUS=/usr/include/dbus-1.0
DIR_INCLUDE_SOCKET=/usr/include/arpa
HEAD_INCLUDE=-I$(DIR_SYS_INC) -I$(DIR_INCLUDE_LOCAL) -I$(DIR_INCLUDE_DBUS) -I$(DIR_INCLUDE_SOCKET)

DIR_LIB_CONFIG=/usr/lib/pkgconfig
DIR_COMMON_MAKEFILE=$(DIR_WORK_ROOT)/common/makefile_common.mk

$(shell export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(DIR_SYS_LIB))

PKG_DBUS=$(wildcard $(DIR_LIB_CONFIG)/dbus-1.pc)
ifneq "$(PKG_DBUS)" ""
PKG_CONFIG_DBUS=`pkg-config "dbus-1 > 1.0.0" --cflags --libs`
else
#$(info *WARNING* 'DBus' package file no found , the function may not be avaiable)
PKG_CONFIG_DBUS=
endif

PKG_GTK=$(wildcard $(DIR_LIB_CONFIG)/gtk+-2.0.pc)
ifneq "$(PKG_GTK)" ""
PKG_CONFIG_GTK=`pkg-config "gtk+-2.0 > 2.0.0" --cflags --libs`
else
#$(info *WARNING* 'gtk+' package file no found , the function may not be avaiable)
PKG_CONFIG_GTK=
endif

COMPILE_CC=$(CC) -O2 -g $(HEAD_INCLUDE) $< $(PKG_CONFIG_DBUS) $(PKG_CONFIG_GTK) -finput-charset=utf-8 -L$(DIR_SYS_LIB)
COMPILE_CP=$(CP) -O2 -g $(HEAD_INCLUDE) $< $(PKG_CONFIG_DBUS) $(PKG_CONFIG_GTK) -finput-charset=utf-8 -L$(DIR_SYS_LIB)

TEMP_CP=$(CP) -O2 -g $(HEAD_INCLUDE) $(PKG_CONFIG_DBUS) $(PKG_CONFIG_GTK) -finput-charset=utf-8 -L$(DIR_SYS_LIB)

SOURCES=$(wildcard $(MAKEDIR)/sources)
OBJITEM=$(strip $(SOURCES))

DIRS=$(wildcard $(MAKEDIR)/dirs)
ifneq ($(SOURCES),)
    MAKE_CMD=make_file
    include $(SOURCES)

    TARGET_NAME:=$(strip $(TARGET_NAME))
    TARGET_TYPE:=$(strip $(TARGET_TYPE))

    ifeq ($(TARGET_NAME),)
        $(error "*ERROR* variable 'TARGET_NAME' hasn't been set !")
    endif

    ifeq ($(TARGET_TYPE),)
        $(error "*ERROR* variable 'TARGET_TYPE' hasn't been set !")
    endif

    ifeq ($(SOURCES),)
        $(error "*ERROR* variable 'SOURCE_TYPE' hasn't been set ! ")
    endif

    ifneq "$(INCLUDE)" ""
        INCLUDE_EX = $(addprefix -I , $(INCLUDE))
        EXTERN_INC+= $(INCLUDE_EX) 
    endif

    C_SOURCES=$(wildcard $(MAKEDIR)/*.c)
    CPP_SOURCES=$(wildcard $(MAKEDIR)/*.cpp)
    ifneq "$(CPP_SOURCES)" ""
        ifeq "$(C_SOURCES)" ""
            C=$(COMPILE_CP)
        endif
    endif

    ifneq "$(C_SOURCES)" ""
        ifeq "$(CPP_SOURCES)" ""
            C=$(COMPILE_CC)
        endif
    endif

#dispatch c and cpp source code
#
#
    ifeq "$(TARGET_TYPE)" "eco"
        C_FLAGS+=-shared -fPIC
        TARGET_TYPE=.so
    endif
	
	ifeq "$(TARGET_TYPE)" "ecx"
        TARGET_TYPE=
	endif
	
	ifeq "$(TARGET_TYPE)" "lib"
        TARGET_TYPE=.a
        ISLIB=yes
    endif

else #ifneq "$(SOURCES)" ""
    ifneq "$(DIRS)" ""
        MAKE_CMD=
        include $(MAKEDIR)/dirs
    else
        $(error dirs or sources file no found in current directory ($(MAKEDIR)))
    endif
endif

OBJS=$(patsubst %.cpp,%.o,$(SOURCES))
HFILE=$(shell ls *.h)

ifndef MAKE_CMD #if not define MAKE_CMD , then we will go to sub directory recursively

all:travel

travel:
	@for dir in $(DIRS);do $(MAKE) -C $$dir -f $(DIR_COMMON_MAKEFILE) ;done

clean:
	@for dir in $(DIRS);do $(MAKE) -C $$dir -f $(DIR_COMMON_MAKEFILE) clean ;done

rebuild:all clean

global:
	@echo Cleaning ...
	@$(RM) $(DIR_WORK_ROOT)/lib/*.*
	@$(RM) $(DIR_WORK_ROOT)/include/*.*
	@echo Clobber done...

else
 
.PHONY:all clean rebuild global

all:$(DIR_SYS_LIB)/$(TARGET_NAME)

$(OBJS):$(SOURCES)
	$(Q)$(CP) -O2 -g -c -fPIC -finput-charset=utf-8 -DLINUX $(HEAD_INCLUDE) $(EXTERN_INC) $*.cpp -o $@

$(DIR_SYS_LIB)/$(TARGET_NAME):$(OBJS)
	@echo Building $(MAKEDIR)
    ifndef ISLIB
		$(Q)$(TEMP_CP) $(OBJS) -g -rdynamic -o $(DIR_SYS_LIB)/$(TARGET_NAME)$(TARGET_TYPE) -ldl -lrt $(C_FLAGS)
#        ifeq "$(TARGET_TYPE)" "eco"
#			@$(MV) ./*.so $(DIR_WORK_ROOT)/lib
#        endif	
    else
		$(Q)$(AR) rcs $(DIR_SYS_LIB)/$(TARGET_NAME)$(TARGET_TYPE) *.o
#		@$(AR) rcs $(TARGET_NAME)$(TARGET_TYPE) $(DIR_SYS_LIB)/$(OBJS)
#		@$(MV) ./*.a $(DIR_WORK_ROOT)/lib
    endif
	@$(MV) ./*.o $(DIR_WORK_ROOT)/lib
	@$(COPY) ./*.h $(DIR_WORK_ROOT)/include

#	@echo "HFILE = " $(HFILE)
#	$(shell [[ -e *.h ]] && cp ./*.h $(DIR_WORK_INC))
#    ifdef HASHFILE
#	@$(COPY) ./*.h $(DIR_WORK_INC)
#    endif
#$(DIR_SYS_LIB)/$(TARGET_NAME):$(SOURCES)
#	@echo Building $(MAKEDIR)/$@
#	@$(C) $(C_FLAGS) $(EXTERN_INC) -o $(TARGET_NAME)$(TARGET_TYPE)
#	@$(COPY) ./*.h $(DIR_WORK_ROOT)/include
#	@$(MV) ./*.so $(DIR_WORK_ROOT)/lib

clean:
	@echo Cleaning ...
	$(Q)$(RM) $(DIR_SYS_LIB)/$(TARGET_NAME)$(TARGET_TYPE)
	@for obj in $(OBJS);do $(RM) $(DIR_SYS_LIB)/$$obj ;done
	@echo Clean done...

rebuild:clean all

global:
	@echo Cleaning ...
	@$(RM) $(DIR_WORK_ROOT)/lib/*.*
	@$(RM) $(DIR_WORK_ROOT)/include/*.*
	@echo Clobber done...
endif


#clean:
#	$(RM) $(MAKEDIR)/$(TARGET_NAME)$(TARGET_TYPE)

#rebuild:clean all


#define remove_dir
#	@$(RM) $(DIR_SYS_LIB)/*.*
#	@$(RM) $(DIR_SYS_INC)/*.*
#endif


