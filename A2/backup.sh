#!/bin/bash

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


sentinal=1
if [ "$#" -ne 2 ];then
        echo "Error: Expected two input parameters."
        echo "Usage: ./backup.sh <backupdirectory> <fileordirtobackup>"
        exit 1
elif [ ! -d "$(realpath_1 $1)" ]; then
        echo "The directory '$(realpath_1 $1)' does not exist."
        exit 2
elif [ ! -e "$(realpath_1 $2)" ]; then
	#|| [ ! -f $(realpath_1 $2) ]
	echo " The directory $2 does not exist"       
        exit 2
fi

if [ "$(realpath_1 $1)" -ef "$(dirname $(realpath_1 $2))" ]; then
	echo "Both arguments are in the same directory: $(dirname $(realpath_1 $2))"
        exit 2
        #"$(dirname $1)/$(basename $1)" == "$(dirname $2)"
elif [ "$(realpath_1 $1)" -ef "$(realpath_1 $2)" ]; then
	echo "Both arguments are in the same directory: $(realpath_1 $2)"
        exit 2
fi

if [ -e "$(dirname $1)/$(basename $1)/$(basename $2| sed 's/\.[^.]*$//').$(date +"%Y%m%d").tar" ]; then
        echo -n "File '"$(basename $2| sed 's/\.[^.]*$//').$(date +"%Y%m%d").tar"'already exists. Overwrite? (y/n): "
        read yno
        if [ "$yno" == 'y' ]; then
                sentinal=1
        else
                sentinal=0
	fi
fi


now=$(date +"%Y%m%d")
name="$(basename $2| sed 's/\.[^.]*$//')"
final_name="${name}.${now}.tar"

if [ $sentinal -eq 1 ]; then
	dir_path=$(dirname  $(realpath_1 $1))
	dir_base=$(basename $(realpath_1 $1))
	final_dir="${dir_path}/${dir_base}"
	final_dir_tar="$final_dir/$final_name"	
	
	file_path=$(dirname  $(realpath_1 $2))
	file_base=$(basename $(realpath_1 $2))
	final_file="${file_path}/${file_base}"
	tar -cf $final_dir_tar $final_file  > /dev/null 2>&1
        exit 0
  else
        exit 3
fi
