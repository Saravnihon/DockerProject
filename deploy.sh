#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Default values
IMAGE_NAME="my-docker-image"
TAG="latest"
SERVER_USER="user"
SERVER_HOST="server.com"
DOCKER_REGISTRY="saravnihon/dev"

# Check for arguments
if [ $# -ge 1 ]; then
  IMAGE_NAME=$1
fi

if [ $# -ge 2 ]; then
  TAG=$2
fi

if [ $# -ge 3 ]; then
  SERVER_USER=$3
fi

if [ $# -ge 4 ]; then
  SERVER_HOST=$4
fi

if [ $# -ge 5 ]; then
  DOCKER_REGISTRY=$5
fi

# Full image name
FULL_IMAGE_NAME="$IMAGE_NAME:$TAG"
if [ -n "$DOCKER_REGISTRY" ]; then
  FULL_IMAGE_NAME="$DOCKER_REGISTRY/$FULL_IMAGE_NAME"
fi

# Push the Docker image
echo "Pushing Docker image: $FULL_IMAGE_NAME"
docker push "$FULL_IMAGE_NAME"

# SSH into the server and pull the image
echo "Deploying image to server: $SERVER_USER@$SERVER_HOST"
ssh "$SERVER_USER@$SERVER_HOST" << EOF
  echo "Pulling Docker image: $FULL_IMAGE_NAME"
  docker pull "$FULL_IMAGE_NAME"
  echo "Stopping and removing old container (if exists)"
  docker stop "$IMAGE_NAME" || true
  docker rm "$IMAGE_NAME" || true
  echo "Running new container"
  docker run -d --name "$IMAGE_NAME" "$FULL_IMAGE_NAME"
EOF

# Success message
echo "Docker image $FULL_IMAGE_NAME deployed successfully to $SERVER_USER@$SERVER_HOST!"
