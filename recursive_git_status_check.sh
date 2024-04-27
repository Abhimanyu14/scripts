#!/bin/bash

# Script to check status of 

# List of directories to exclude the gitignore updation
excludedDirectories="gitignore/ private-files/ samples/"

# Change to root directory
cd ..

# Iterate over all directories
for dir in */; do

  # Skip directories in exclude directories
  if [[ ${excludedDirectories} != *"$dir"* ]];then

    # Change to that subdirectory
    cd $dir

    if [ "$(git status | grep "nothing to commit, working tree clean")" = "nothing to commit, working tree clean" ]; then
      :
    # elif [ "$(git status | grep "Changes not staged for commit:")" = "Changes not staged for commit:" ]; then
    #   echo ""
    #   echo "$dir"
    #   echo "$(git status)";
    # elif [ "$(git status | grep "Changes to be committed:")" = "Changes to be committed:" ]; then
    #   echo ""
    #   echo "$dir"
    #   echo "$(git status)";
    else 
      echo ""
      echo "$dir"
      echo "$(git status)";
    fi

    # Change back to the root directory
    cd ..
  fi
done

# Empty line
echo ""
echo "Git status check completed!"
echo ""
