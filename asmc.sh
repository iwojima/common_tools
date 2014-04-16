
#!/bin/sh

export DBEBUG=""
export DETAIL=" 2>/dev/null"
export ISLINK="TRUE"
export ISSO="FALSE"

function showHelp
{
	#echo "<-------- help information -------->"
	echo "Usage: asmc [option...] [asmfile...]"
	echo "Option:"
	echo " -g       add debug information     "
	echo " -v       show detail information   "
	echo " -c       compile without linking   "
	echo " -s       shared object. the option "
	echo "          must be set with '-c'     "
	echo " -h       show the message          "
	#echo "<---------------------------------->"
	exit
}

#if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
#	showHelp
#fi

if [ "$1" == "" ] || [ "$1" == " " ]; then
	showHelp
fi

for arg in $@; do
	case $arg in
		-h)
			showHelp
			;;
		--help)
			showHelp
			;;
		-g)
			export DBEBUG="--gstabs"
			;;
		-v)
			export DETAIL=""
			;;
		-c)
			export ISLINK="FALSE"
			;;
		-s)
			export ISSO="TRUE"
			;;
		*) 
			export sourcename=$arg
			export filename=`echo $arg | sed  -e "s/[.][a-z0-9_()-<>&#@]*//"`
			export fileextend=`echo $arg | sed  -e "s/[a-z0-9_()-<>&#@]*//"`
			;;
	esac
done

#export filename=`echo $1 | sed  -e "s/[.][a-z0-9_()-<>&#@]*//"`
#export fileextend=`echo $1 | sed  -e "s/[a-z0-9_()-<>&#@]*//"`

#echo $1

export MidObjtype=".o"

#echo filename = $filename , fileextend = $fileextend

if [ ! $fileextend == ".asm" ] && [ ! $fileextend == ".s" ]; then
    echo "*ERROR* Invalid file type , Please select valid file ! fileextend = "$fileextend
	exit
fi

if [ ! -e "./"$sourcename ]; then
    echo "*ERROR* Source file doesn't exits ! Please check"
	exit
fi

#if [ $fileextend == ".asm" ]; then
#    export CMD="nasm -f -elf"
#elif [ $fileextend == ".s" ]; then
#    export CMD="as -o "
#else
#    echo "*ERROR* Invalid extend name !"
#	exit
#fi

if [ -e "./"$filename ]; then
	echo "rm -rf $filename"
    rm -rf "./"$filename
fi

if [ -e "./"$filename$MidObjtype ]; then
	echo "rm -rf $filename$MidObjtype"
    rm -rf "./"$filename$MidObjtype
fi

if [ -e "/usr/bin/as" ]; then
    if [ -e "/usr/bin/ld" ]; then
        #echo "Success !"
        #nasm -f elf "$1"
		
		export OBJ=$filename$MidObjtype
		
		if [ $fileextend == ".asm" ]; then
		    #
			nasm -f elf $sourcename
		elif [ $fileextend == ".s" ]; then
		    #
			as $DBEBUG -o $OBJ $sourcename
		fi

		if [ ! -e  "./"$OBJ ]; then
		    echo "*ERROR* Fail to fetch mid file !"
			exit
		fi
		
		if [ $ISSO == "TRUE" ]; then
			g++ -shared -o lib$filename.so $OBJ
		fi
		
		if [ $ISLINK == "TRUE" ]; then
			ld -o $filename $OBJ -Ttext 1000
			if [ ! -e "./"$filename ] && [ ! $? == "0" ]; then
				echo "*ERROR* Fail to link object file to bin !"
				echo "S? = "$?
				exit
			fi
		fi
		#if [ ! $? == "0" ]; then
		#    echo "Return Value invalid !"
		#	exit
		#fi
		
		echo "OK !"
		
	fi
fi

