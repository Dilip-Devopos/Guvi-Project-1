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
