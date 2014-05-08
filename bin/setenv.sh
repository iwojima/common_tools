#!/bin/sh
export IWORK_HOME=/home/stewart/iWork
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$IWORK_HOME/lib:$IWORK_HOME/Thrid_party/ACE_wrappers_linux/lib
export PATH=$PATH:$IWORK_HOME/common/bin
export ACE_ROOT=$IWORK_HOME/Thrid_party/ACE_wrappers

alias cls=clear
alias vi=vim
alias s='gnome-open . > /dev/null'
alias gedit='gedit $* > /dev/null'
alias egrep='egrep --color'
alias grep='grep --color'
alias gb='cd /home/stewart'
alias gd='cd /home/stewart/Desktop'
alias pd='source /home/stewart/iWork/common/bin/pd.sh $*'
alias work='source /home/stewart/iWork/common/bin/setenv.sh'
alias emake='/home/stewart/iWork/common/bin/e_make.sh $*'
alias e='emake'
alias er='emake rebuild'

ulimit -c unlimited
ulimit unlimited

export CURRENT_PATH=`pwd`
export WORK_PATH=`echo $CURRENT_PATH | grep iWork`
if [ -z $WORK_PATH ]; then
	cd /home/`whoami`/iWork
fi



