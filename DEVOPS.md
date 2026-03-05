# AidConnect DevOps Guide

## Overview
This document outlines the complete DevOps setup for the AidConnect NGO Management System.

## 🐳 Docker Setup

### Local Development
```bash
# Run production build
docker-compose up --build

# Run development version with hot reload
docker-compose --profile dev up
```

### Build and Run Manually
```bash
# Build image
docker build -t aidconnect-frontend .

# Run container
docker run -p 80:80 aidconnect-frontend
```

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow
The CI/CD pipeline includes:
- **Testing**: Automated tests with coverage
- **Security**: Vulnerability scanning with Trivy
- **Building**: Multi-stage Docker builds
- **Deployment**: Automated deployment to staging/production

### Pipeline Triggers
- **Push to main**: Build, test, security scan, deploy to production
- **Push to develop**: Build, test, security scan, deploy to staging
- **Pull requests**: Build, test, security scan

## ☸️ Kubernetes Deployment

### Prerequisites
- Kubernetes cluster (v1.20+)
- kubectl configured
- NGINX Ingress Controller
- cert-manager for SSL certificates

### Deployment Commands
```bash
# Deploy to Kubernetes
chmod +x scripts/deploy.sh
./scripts/deploy.sh production

# Build and push new image
chmod +x scripts/build-and-push.sh
./scripts/build-and-push.sh v1.0.0
```

### Kubernetes Resources
- **Namespace**: `aidconnect`
- **Replicas**: 3 (auto-scaling 3-10)
- **Service**: ClusterIP on port 80
- **Ingress**: HTTPS with Let's Encrypt
- **HPA**: Auto-scaling based on CPU/Memory

## 🔧 Configuration

### Environment Variables
- `NODE_ENV`: production/development
- `REACT_APP_API_URL`: Backend API endpoint

### Security Features
- Non-root containers
- Read-only filesystem
- Resource limits
- Health checks
- SSL/TLS encryption
- Security headers

## 📊 Monitoring

### Health Checks
- **Liveness Probe**: `/` every 30s
- **Readiness Probe**: `/` every 5s

### Resource Limits
- **CPU**: 50m request, 100m limit
- **Memory**: 64Mi request, 128Mi limit

### Auto-scaling
- **Min Replicas**: 3
- **Max Replicas**: 10
- **CPU Target**: 70%
- **Memory Target**: 80%

## 🛠️ Local Development Setup

### Prerequisites
- Docker Desktop
- Node.js 18+
- kubectl (for Kubernetes deployment)

### Quick Start
```bash
# Install dependencies
npm install

# Start development server
npm start

# Or use Docker
docker-compose --profile dev up
```

## 🚨 Troubleshooting

### Common Issues
1. **Port conflicts**: Ensure ports 80 and 3000 are available
2. **Image build failures**: Check Dockerfile and dependencies
3. **Kubernetes deployment**: Verify cluster connection and permissions

### Logs
```bash
# Docker logs
docker-compose logs -f

# Kubernetes logs
kubectl logs -f deployment/aidconnect-frontend -n aidconnect
```

## 📝 Deployment Checklist

### Before Deployment
- [ ] Tests passing
- [ ] Security scan clean
- [ ] Image built successfully
- [ ] Environment variables configured

### After Deployment
- [ ] Health checks passing
- [ ] SSL certificate valid
- [ ] Auto-scaling working
- [ ] Monitoring configured

## 🔐 Security Considerations

- Images scanned for vulnerabilities
- Non-root container execution
- Minimal attack surface
- Regular dependency updates
- SSL/TLS encryption
- Security headers configured

## 📈 Performance Optimization

- Multi-stage builds for smaller images
- Gzip compression enabled
- Static asset caching
- CDN integration ready
- Auto-scaling configured
