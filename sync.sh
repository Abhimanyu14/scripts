#!/bin/bash

# Record the start time
start_time=$(date +%s)

# Script to sync all repos

# List of directories to exclude the gitignore updation
excludedDirectories="samples/"

# Change to root directory
cd ..

# Function to sync changes for a single repository
sync_changes() {
  
  local dir=$1

  # Change to that subdirectory
  cd "$dir" || return
  
  # Stash local changes
  git stash >/dev/null 2>&1

  # Checkout the main branch
  git checkout main >/dev/null 2>&1

  # Pull from the remote
  git pull origin main >/dev/null 2>&1

  if [[ "$(git status | grep "Changes not staged for commit:")" == "Changes not staged for commit:" || 
  "$(git status | grep "Untracked files:")" == "Untracked files:" ]]; then
    # Changes not staged
    echo -e "\n$dir \n$(git status) \n"
  elif [[ "$(git status | grep "Changes to be committed:")" == "Changes to be committed:" ]]; then
    # Changes staged, but not commited 
    echo -e "\n$dir \n$(git status) \n"
  elif [[ "$(git status | grep "Your branch is ahead of")" =~ "Your branch is ahead of" ]]; then
    # Changes commited, but not pushed 
    
    # Print the directory name
    echo -e "\n$dir"

    # Push the latest commits
    git push origin main >/dev/null 2>&1
  elif [[ "$(git status | grep "nothing to commit, working tree clean")" == "nothing to commit, working tree clean" ]]; then
    # No new changes 
    :
  else 
    echo -e "\n$dir \n$(git status) \n"
  fi

  # Pop the stashed changes
  git stash pop >/dev/null 2>&1

  # Change back to the root directory
  cd ..
}

# Export the function to make it available to parallel
export -f sync_changes

# Iterate over all directories
for dir in */; do

  # Skip directories in exclude directories
  if [[ $excludedDirectories != *"$dir"* ]]; then
    
    # Run sync_changes function in parallel for each directory
    sync_changes "$dir" &
  fi
done

# Wait for all background processes to finish
wait

# Record the end time
end_time=$(date +%s)

# Calculate the duration
duration=$((end_time - start_time))

# Empty line
echo "
Git changes synced in ${duration} seconds!
"
