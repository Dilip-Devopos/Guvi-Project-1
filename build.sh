#####################################################################################################################################################################
# This script builds a Docker image and tags it based on the branch name.
# Usage: ./build_and_tag.sh <image_name> <version> <branch_name>
# Example: ./build_and_tag.sh guvi-project-1 5 main
# Example: ./build_and_tag.sh guvi-project-1 5 dev
# Ensure the script exits on error and prints commands
####################################################################################################################################################################
# Author: kdilipkumar
# Date: 2023-10-01
# Version: 1.0
####################################################################################################################################################################
#!/bin/bash

set -e
set -x

image_name=$1       # guvi-project-1
version=$2          # 5
branch_name=$3      # e.g. main or dev

# Decide repo based on branch name
if [ "$branch_name" = "main" ]; then
  repo="kdilipkumar/prod"
else
  repo="kdilipkumar/dev"
fi

# Build Docker image
docker build -t ${image_name}:${version} .

# Tag it for the appropriate repo
docker tag ${image_name}:${version} ${repo}:${version}
