#!/bin/bash
set -e
set -x

image_name=$1
version=$2

# Build the Docker image
docker build -t ${image_name}:${version} .

# Tag for Docker Hub (e.g., kdilipkumar/guvi-dev or kdilipkumar/guvi-prod)
docker tag ${image_name}:${version} ${3}/${image_name}:${version}
