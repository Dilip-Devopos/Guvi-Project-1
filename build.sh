#!/bin/bash
set -e
set -x

image_name=$1
version=$2
repo=$3

# Build the Docker image
docker build -t ${image_name}:${version} .

# Tag for Docker Hub - dev tag
docker tag ${image_name}:${version} ${repo}:${version}