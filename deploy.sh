#!/bin/bash

set -e
set -x

# Parameters
image_name=$1
version=$2

# Pull the image from Docker Hub
docker pull kdilipkumar/$image_name:$version

# Stop and remove old container (optional cleanup)
docker rm -f $image_name || true

# Run the container
docker run -d --name $image_name -p 80:80 kdilipkumar/$image_name:$version
