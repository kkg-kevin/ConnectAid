#!/bin/bash

# AidConnect Staging Deployment Script
# Usage: ./scripts/deploy-staging.sh

set -e

ENVIRONMENT="staging"
NAMESPACE="aidconnect-staging"
IMAGE_TAG="develop"

echo "🚀 Starting deployment to $ENVIRONMENT environment..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

# Create namespace if it doesn't exist
echo "📦 Creating staging namespace..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Apply staging Kubernetes manifests
echo "🔧 Applying staging Kubernetes manifests..."
kubectl apply -f k8s/staging/namespace.yaml
kubectl apply -f k8s/staging/deployment.yaml
kubectl apply -f k8s/staging/service.yaml
kubectl apply -f k8s/staging/ingress.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/aidconnect-frontend -n $NAMESPACE --timeout=300s

# Get deployment status
echo "📊 Deployment status:"
kubectl get pods -n $NAMESPACE -l app=aidconnect-frontend
kubectl get services -n $NAMESPACE
kubectl get ingress -n $NAMESPACE

echo "✅ Staging deployment completed successfully!"
echo "🌐 Application should be available at: https://staging.aidconnect.com"
