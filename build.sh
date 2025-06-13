set -e 
set -x

# remove any existing devops-build directory
# rm -rf devops-build/

# clone the repository
# git clone https://github.com/sriram-R-krishnan/devops-build.git

# copy the Dockerfile into the cloned repository
# cp Dockerfile Guvi-Project-1/

# change directory to devops-build
cd Guvi-Project-1

# build and push the Docker image
image_name=$1
version=$2

# docker build command
docker build -t $image_name:$version .


# tag the image with the Docker Hub repository
docker tag $image_name:$version kdilipkumar/$image_name:$version

# push the image to Docker Hub  
docker push kdilipkumar/$image_name:$version
