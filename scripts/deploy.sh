#!/bin/bash

# AidConnect Frontend Deployment Script
# Usage: ./scripts/deploy.sh [environment]

set -e

ENVIRONMENT=${1:-production}
NAMESPACE="aidconnect"
IMAGE_TAG=${2:-latest}

echo "🚀 Starting deployment to $ENVIRONMENT environment..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

# Create namespace if it doesn't exist
echo "📦 Creating namespace..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Apply Kubernetes manifests
echo "🔧 Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/aidconnect-frontend -n $NAMESPACE --timeout=300s

# Get deployment status
echo "📊 Deployment status:"
kubectl get pods -n $NAMESPACE -l app=aidconnect-frontend
kubectl get services -n $NAMESPACE
kubectl get ingress -n $NAMESPACE

echo "✅ Deployment completed successfully!"
echo "🌐 Application should be available at: https://aidconnect.yourdomain.com"
