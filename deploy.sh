#####################################################################################################################################################################
# Docker Deployment Script
# This script pulls a Docker image from Docker Hub and runs it as a container.
# Usage: ./deploy_docker.sh <image_name> <version>
#####################################################################################################################################################################
# Author: kdilipkumar
# Date: 2023-10-01
# Version: 1.0
#####################################################################################################################################################################
#!/bin/bash

set -e
set -x

# This script deploys a Docker container from an image pulled from Docker Hub.
# Parameters
image_name=$1
version=$2

# Pull the image from Docker Hub
docker pull kdilipkumar/$image_name:$version

# Stop and remove old container (optional cleanup)
docker rm -f $image_name || true

# Run the container
docker run -d --name $image_name -p 80:80 kdilipkumar/$image_name:$version
