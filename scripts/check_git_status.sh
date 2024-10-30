#!/bin/bash

# Check if a path is provided as the second argument
if [ -n "$1" ]; then
    base_dir="$1"
else
    base_dir="."
fi

# Scan for git repositories recursively starting from the specified directory
find "$base_dir" -type d -name ".git" | while read -r git_dir; do
    # Go to the git directory's parent
    repo_dir=$(dirname "$git_dir")
    cd "$repo_dir" || continue

    # Check if the repository is dirty (uncommitted changes)
    if [ -n "$(git status --porcelain)" ]; then
        echo "$repo_dir has uncommitted changes"
    fi

    # Check if the repository is outdated (behind origin)
    git fetch --quiet
    local_commit=$(git rev-parse @)
    remote_commit=$(git rev-parse @{u} 2>/dev/null)

    if [ "$local_commit" != "$remote_commit" ]; then
        echo "$repo_dir is behind the remote"
    fi

    # Return to the starting directory
    cd - > /dev/null || exit
done

