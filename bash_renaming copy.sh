#!/bin/bash #shebang line -- tells OS which interpreter to use

#Check if correct # of args is provided
if [ "$#" -ne 3 ]; then # check if # of args passed to script ($#) is not equal to 3
	echo "Usage: $0 <base_directory> <search_string> <replacement_string>" # $0 holds the script filename/path
fi # closes the if statement in Bash

base_dir="$1"
search_string="$2"
replacement_string="$3"

rename_items() {
	for item in "$1"/*; do #$1 is the first argument in the function (it will be base_dir)
	# "$1"/* expands to all items in the directory (files and directories--subdirectories)--loop will iterate over each file/folder individually
		if [ -d "$item" ]; then # check if current item its iterating over is a directory
			new_item=$(echo "$item" | sed "s/$search_string/$replacement_string/g") #sed: stream editor
			# sed used to replace occurences of search_string with replacement_string in item name (s stands for substitute)
			if [ "$item" != "$new_item" ]; then # check if new name is different from old name (item)
                mv "$item" "$new_item" # rename item using mv
            fi
            rename_items "$new_item" # recursive call for directories --> call rename_itmes function on renamed diretory to process subfolder's contents
            # ^ since it's in the if loop, this line only runs if $item is a directory
        elif [ -f "$item" ]; then # use -f test to see if the item is a file
            # If it's a file, rename it
            new_item=$(echo "$item" | sed "s/$search_string/$replacement_string/g")
            if [ "$item" != "$new_item" ]; then
                mv "$item" "$new_item"
            fi
        fi
    done
}

# Start the renaming process from the base directory
rename_items "$base_dir"

#-----------------------------------------------------------------------------------------------

# run 'chmod +x rename_items.sh' to make scipt executable
# run:
# 	./rename_items.sh /path/to/base/dir "---Use Current State---" "_"