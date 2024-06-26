#!/bin/bash

# Record the start time
start_time=$(date +%s)

# Script to check status of all repos

# List of directories to exclude the gitignore updation
excludedDirectories="samples/"

# Change to root directory
cd ..

# Function to check stash for a single repository
check_stash() {
  
  local dir=$1

  # Change to that subdirectory
  cd "$dir" || return
  
  # Checkout the main branch
  git checkout main >/dev/null 2>&1

  # Pull from the remote
  git pull origin main >/dev/null 2>&1

  if [ "$(git stash list)" != "" ]; then
    echo -e "\n$dir \n$(git stash list)"
  fi

  # Change back to the root directory
  cd ..
}

# Export the function to make it available to parallel
export -f check_stash

# Iterate over all directories
for dir in */; do

  # Skip directories in exclude directories
  if [[ $excludedDirectories != *"$dir"* ]]; then
    
    # Run check_stash function in parallel for each directory
    check_stash "$dir" &
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
Git stash check completed in ${duration} seconds!
"
