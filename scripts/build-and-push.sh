#!/bin/bash

# Build and Push Docker Image Script
# Usage: ./scripts/build-and-push.sh [tag]

set -e

TAG=${1:-latest}
REGISTRY="ghcr.io"
IMAGE_NAME="kkg-kevin/aidconnect-frontend"
FULL_IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$TAG"

echo "🔨 Building Docker image: $FULL_IMAGE_NAME"

# Build the Docker image
docker build -t $FULL_IMAGE_NAME .

echo "📤 Pushing Docker image: $FULL_IMAGE_NAME"

# Push the Docker image
docker push $FULL_IMAGE_NAME

echo "✅ Build and push completed successfully!"
echo "🏷️  Image: $FULL_IMAGE_NAME"

# Update Kubernetes deployment with new image tag
echo "🔄 Updating Kubernetes deployment..."
kubectl set image deployment/aidconnect-frontend aidconnect-frontend=$FULL_IMAGE_NAME -n aidconnect

# Wait for rollout to complete
echo "⏳ Waiting for rollout to complete..."
kubectl rollout status deployment/aidconnect-frontend -n aidconnect --timeout=300s

echo "✅ Deployment updated with new image!"
