# Exit immediately if a command exits with a non-zero status
set -e

# Default values
IMAGE_NAME="my-docker-image"
TAG="latest"

# Check for arguments
if [ $# -ge 1 ]; then
  IMAGE_NAME=$1
fi

if [ $# -ge 2 ]; then
  TAG=$2
fi

# Build the Docker image
echo "Building Docker image: $IMAGE_NAME:$TAG"
docker build -t "$IMAGE_NAME:$TAG" .

# Success message
echo "Docker image $IMAGE_NAME:$TAG built successfully!"