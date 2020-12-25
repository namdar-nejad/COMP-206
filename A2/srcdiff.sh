#!/bin/bash


sentinal=0

# This is a function that gives the absolute path
# Got a part of this function from github and have modified it

function realpath_1()

{

	local success=true

	local path="$1"

	

	# make sure the string isn't empty as that implies something in further logic

	if [ -z "$path" ]; then

		success=false

	else

		# start with the file name (sans the trailing slash)

		path="${path%/}"

		

		# if we stripped off the trailing slash and were left with nothing, that means we're in the root directory

		if [ -z "$path" ]; then

			path="/"

		fi

		

		# get the basename of the file (ignoring '.' & '..', because they're really part of the path)

		local file_basename="${path##*/}"

		if [[ ( "$file_basename" = "." ) || ( "$file_basename" = ".." ) ]]; then

			file_basename=""

		fi

		

		# extracts the directory component of the full path, if it's empty then assume '.' (the current working directory)

		local directory="${path%$file_basename}"

		if [ -z "$directory" ]; then

			directory='.'

		fi

		

		# attempt to change to the directory

		if ! cd "$directory" &>/dev/null ; then

			success=false

		fi

		

		if $success; then

			# does the filename exist?

			if [[ ( -n "$file_basename" ) && ( ! -e "$file_basename" ) ]]; then

				success=false

			fi

			

			# get the absolute path of the current directory & change back to previous directory

			local abs_path="$(pwd -P)"

			cd "-" &>/dev/null

			  

			# Append base filename to absolute path

			if [ "${abs_path}" = "/" ]; then

				abs_path="${abs_path}${file_basename}"

			else

				abs_path="${abs_path}/${file_basename}"

			fi

			

			# output the absolute path

			echo "$abs_path"

		fi

	fi

	

	$success

}


# Assignment code begins here:

if [ "$#" -ne 2 ];then
        echo "Error: Expected two input parameters."
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 1
fi
	
Dir1_name="$(realpath_1 "$1")" >/dev/null 2>/dev/null
Dir2_name="$(realpath_1 "$2")" >/dev/null 2>/dev/null

if [ ! -e $Dir1_name ] || [ ! -d $Dir1_name ]; then
	echo "Error: Input parameter #1 $1 is not a directory."
        echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
        exit 2
elif [ ! -e $Dir2_name ] || [ ! -d $Dir2_name ]; then
        echo "Error: Input parameter #2 $2 is not a directory."
        echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
        exit 2
elif [[ $(realpath_1 "$Dir1_name") == $(realpath_1 $Dir2_name) ]]; then
	echo "Error: Input parameter are the same, enter diffrent directories."
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 2
fi

Dir1_list=$(ls $1) >/dev/null 2>/dev/null
Dir2_list=$(ls $2) > /dev/null 2>/dev/null

# Compering Dir2 files with Dir1 files

for file in $Dir1_list; do
	
	name=$(basename $file)
    if [[ ! -f $Dir2_name/$name ]]; then
	sentinal=1
	echo "$Dir2_name/$name missing"
    fi
done

# Compering Dir2 files with Dir1 files

for file in $Dir2_list; do

        name=$(basename $file)
    if [[ ! -f $Dir1_name/$name ]]; then
        sentinal=1
	echo "$Dir1_name/$name missing"
    fi
done

# Comparing the contents of the files
    for j in $Dir2_list; do
	    for i in $Dir1_list; do
	    name_i=$(basename $i)
	    name_j=$(basename $j)

if [[ $name_i == $name_j ]]; then
	dif=$(diff "$Dir1_name/$name_i" "$Dir2_name/$name_j" | grep "^>\|^<" | wc -l) >/dev/null 2>/dev/null         
		if [ $dif != 0 ]; then
			sentinal=1
			echo "$Dir1_name/$name_i differs"
		fi			
	fi
	done
done

if [[ $sentinal == 1 ]]; then
	exit 3
else 
	exit 0
fi
