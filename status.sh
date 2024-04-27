#!/bin/bash

# Record the start time
start_time=$(date +%s)

# Script to check status of all repos

# List of directories to exclude the gitignore updation
excludedDirectories="gitignore/ private-files/ samples/"

# Change to root directory
cd ..

# Function to check status for a single repository
check_status() {
  
  local dir=$1

  # Change to that subdirectory
  cd "$dir" || return
  
  # Checkout the main branch
  git checkout main >/dev/null 2>&1

  # Pull from the remote
  git pull origin main >/dev/null 2>&1

  if [ "$(git status | grep "nothing to commit, working tree clean")" != "nothing to commit, working tree clean" ]; then
    echo ""
    echo "$dir"
    echo "$(git status)"
  fi

  # Change back to the root directory
  cd ..
}

# Export the function to make it available to parallel
export -f check_status

# Iterate over all directories
for dir in */; do

  # Skip directories in exclude directories
  if [[ $excludedDirectories != *"$dir"* ]]; then
    
    # Run check_status function in parallel for each directory
    check_status "$dir" &
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
Git status check completed in ${duration} seconds!
"