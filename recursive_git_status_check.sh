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

    # Print current directory name
    echo ""
    echo ""
    pwd

    # Check status
    git status

    # Change back to the root directory
    cd ..
  fi
done
