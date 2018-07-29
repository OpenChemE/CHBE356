#!/bin/bash

# a pattern that matches nothing "disappears", rather than treated as a literal string:
# https://unix.stackexchange.com/questions/239772/bash-iterate-file-list-except-when-empty
shopt -s nullglob

# Our paths for the readme file
header_path="header.md"
readme_path="README.md"
nbviewer_path="http://nbviewer.jupyter.org/github/OpenChemE/CHBE356/blob/master/Notebooks" 

# Copy the header over and add a blank line
cat "$header_path" > "$readme_path"
echo -e "\n" >> "$readme_path"

# https://stackoverflow.com/questions/3362920/get-just-the-filename-from-a-path-in-a-bash-script
for d in ./Notebooks/* ; do
	xpath=${d%/*} 
	xbase=${d##*/}
	xfext=${xbase##*.}
	xpref=${xbase%.*}

    echo "# $xbase" >> "$readme_path"
    
    for f in "$d"/*.ipynb; do
		fpath=${f%/*} 
		fbase=${f##*/}
		ffext=${fbase##*.}
		fpref=${fbase%.*}

    	echo "* [$fpref]($nbviewer_path/${xbase// /%20}/${fbase// /%20})" >> "$readme_path"
    done

    echo -e "\n" >> "$readme_path"

done

# # Setup and push to master
git config --global user.email ${GIT_EMAIL}
git config --global user.name ${GIT_NAME}
git add .
git commit --message "Travis update README.MD: $TRAVIS_BUILD_NUMBER"
git remote set-url origin https://${GH_TOKEN}@github.com/OpenChemE/CHBE356.git
git push -u origin master