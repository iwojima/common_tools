###########################################################################
#
# File:     $/XDK/DevKit/tools/pd.bat
# Purpose:  quick jump to target dir & shorthand for pushd and popd
# Usage:    pd [ -? | directory | ~ | @ | inc | lib | cls ]
# Date:     2000-4-24
#
###########################################################################
WORK_ROOT=/home/`whoami`/iWork

if [ "$1" == "-h" ]; then
    echo "usage: pd DIR     (same as PUSHD DIR)"
    echo "       pd         (same as POPD)"
    echo "       pd m       (PUSHD to mirror directory)"
    echo "       pd p       (PUSHD to android package directory or msvc win32 app directory)"
    echo "       pd @       (PUSHD to target directory)"
    echo "       pd inc     (PUSHD to compiled INC directory)"
    echo "       pd lib     (PUSHD to compiled LIB directory)"
    echo "       pd cls     (PUSHD to compiled CLS directory)"
elif [ "$1" == "" ]; then
    popd
elif [ "$1" == "@" ]; then
    
    pushd $WORK_ROOT/lib
    #echo 'pwd = '`pwd`
elif [ "$1" == "inc" ]; then
    pushd $WORK_ROOT/include
elif [ "$1" == "cls" ]; then
    pushd $XDK_USER_OBJ/$XDK_BUILD_KIND/$1
elif [ "$1" == "lib" ]; then
    pushd $XDK_USER_OBJ/$XDK_BUILD_KIND/$1
elif [ "$1" == "m" ]; then
    PROJECT_DIR=$PWD
#    temp_dir=${XDK_ROOT/XDK*/}
    XDK_EMAKE_DIR=${PWD/$XDK_SOURCE_PATH/}
    pushd $XDK_USER_OBJ/$XDK_BUILD_KIND/mirror$XDK_EMAKE_DIR
elif [ "$1" == "p" ]; then
    PROJECT_DIR=$PWD
    temp_dir=`dirname $PROJECT_DIR`
    XDK_EMAKE_DIR=${PROJECT_DIR/$temp_dir/}
    if [ "$XDK_TARGET_PLATFORM" = "win32" ]; then
        if [ -d $XDK_TARGETS$XDK_EMAKE_DIR ]; then
            pushd $XDK_TARGETS$XDK_EMAKE_DIR
        else
            pushd $XDK_TARGETS
        fi
    elif [ "$XDK_TARGET_PLATFORM" = "openkode" ]; then
        if [ -d $XDK_USER_OBJ/$XDK_BUILD_KIND/package$XDK_EMAKE_DIR ]; then
            pushd $XDK_USER_OBJ/$XDK_BUILD_KIND/package$XDK_EMAKE_DIR
        else
            pushd $XDK_USER_OBJ/$XDK_BUILD_KIND/package
        fi
    fi
else
    pushd $1
fi

