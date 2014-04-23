#!/bin/bash

export MAKE_INFO=`which make`
if [ -z $MAKE_INFO ]; then
    echo "*ERROR* 'make' no found in your system"
    exit
fi

export EXECUTE_USER=`whoami`
#if [ ! $EXECUTE_USER == "stewart" ]; then
#    echo "*ERROR* Invalid User"
#    exit
#fi

export MY_MAKEFILE_DIR=~/iWork/common
export MAKE_START=`date +%s`
make -f $MY_MAKEFILE_DIR/makefile_common.mk $1
export MAKE_END=`date +%s`
export TIME_COST=$(($MAKE_END-$MAKE_START))
#echo $TIME_COST
export HOUR_COST=$(($TIME_COST/3600))
export MINUTE_COST=
export SECOND_COST=


