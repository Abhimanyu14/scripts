#!/bin/bash

# Record the start time
start_time=$(date +%s)

# Script to check status of all repos

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

    # Checkout the main branch
    git checkout main >/dev/null 2>&1

    # Pull from the remote
    git pull origin main >/dev/null 2>&1

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

# Record the end time
end_time=$(date +%s)

# Calculate the duration
duration=$((end_time - start_time))

# Empty line
echo ""
echo "Git status check completed in ${duration} seconds!"
echo ""
