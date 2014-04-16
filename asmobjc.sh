
#!/bin/sh

export asm_filename=""
export c_filename=""
export c_mainfileex=""


export ISDBUG=""
export TARGET=".o"
export CC=""

function showHelp
{
	echo "Usage: asmoc [asm_filename ...] [c_filename ...]"
	echo "Option:"
	echo " -g           set debug info"
	echo " -v           show version info"
	exit
}

function showMessage
{
	echo "Asmoc 1.0"
	echo "The application is to build asm's obj file and its test main"
	exit
}


if [ "$1" == "" ] || [ "$1" == " " ]; then
	showHelp
fi

for arg in $@; do
	case $arg in
	-h)
		showHelp
		;;
	-g)
		export ISDBUG="-g"
		;;
	-v)
		showMessage
		;;
	*)
		export filename=`echo $arg | sed  -e "s/[.][a-z0-9_()-<>&#@]*//"`
		export fileextend=`echo $arg | sed  -e "s/[a-z0-9_()-<>&#@]*//"`
		
		if [ $fileextend == ".s" ]; then
			export asm_filename=$filename
		elif [ $fileextend == ".c" ]; then
			export c_filename=$filename
			export CC=gcc
			export c_mainfileex=$fileextend
		elif [ $fileextend == ".cpp" ]; then
			export c_filename=$filename
			export CC=g++
			export c_mainfileex=$fileextend
		else
			echo "*ERROR* Invalid ExtentName : "$fileextend
			exit
		fi
		;;
	esac
done

if [ ! -e ./$asm_filename.s ] || [ ! -e ./$c_filename.c ];then
	echo "*ERROR* sepify file doesn't exit !"
	exit
fi

if [ ! -e /usr/bin/as ] || [ ! -e /usr/bin/gcc ];then
	echo "*ERROR* lost importmation file !"
	exit
fi

if [ -e $asm_filename$TARGET ];then
	rm -rf $asm_filename$TARGET
fi

if [ -e $c_filename$TARGET ]; then
	rm -rf $c_filename$TARGET
fi

if [ -e $c_filename ]; then
	rm -rf $c_filename
fi

as $ISDBUG -o $asm_filename$TARGET $asm_filename.s
if [ ! -e ./$asm_filename$TARGET ]; then   #|| 
	echo "*ERROR* Fail to build asm obj file !"
	exit
fi

#$CC -c $ISDBUG $c_filename$c_mainfileex
#echo "$CC -c $ISDBUG $c_filename$c_mainfileex"
#if [ ! -e  ./$c_filename$TARGET ]; then
#	echo "*ERROR* Fail to build c/c++ obj file ! "$?
#	exit
#fi

$CC -o $c_filename $c_filename$c_mainfileex $asm_filename$TARGET $ISDBUG
if [ ! -e $c_filename ]; then
	echo "*ERROR* Fail to build final file !"
	exit
fi

echo OK








