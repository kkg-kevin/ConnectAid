# AidConnect DevOps Guide

## Overview
This document outlines the complete DevOps setup for the AidConnect NGO Management System.

## � Complete CI/CD Pipeline Summary

### Pipeline Triggers
- **Push to `main` branch**: Full pipeline → Production deployment
- **Push to `develop` branch**: Full pipeline → Staging deployment  
- **Pull Request to `main`**: Test and security only (no deployment)

### Pipeline Stages

#### Stage 1: Test Job 🧪
**Purpose**: Validate code quality and functionality

**Steps:**
1. **Checkout Code** (2s) - Downloads source code from GitHub
2. **Setup Node.js** (15s) - Installs Node.js v20 with npm cache
3. **Install Dependencies** (30s) - Runs `npm install` for all packages
4. **Run Tests** (10s) - Executes automated tests with coverage

**Outputs:**
- ✅ Test results and coverage
- ✅ Code quality validation
- ✅ Ready for security scanning

#### Stage 2: Security Job 🔒
**Purpose**: Scan for vulnerabilities and security issues

**Steps:**
1. **Checkout Code** (2s) - Downloads source code (parallel to test job)
2. **Run Trivy Scanner** (45s) - Scans files and dependencies for vulnerabilities
3. **Upload Security Results** (5s) - Uploads SARIF report to GitHub Security tab

**Outputs:**
- ✅ Security vulnerability report
- ✅ GitHub Security tab integration
- ✅ Compliance documentation

#### Stage 3: Build and Push Job 🐳
**Purpose**: Create and distribute Docker image

**Steps:**
1. **Checkout Code** (2s) - Downloads source code
2. **Login to Container Registry** (5s) - Authenticates with GitHub Container Registry
3. **Extract Metadata** (3s) - Generates Docker image tags and labels
4. **Setup Docker Buildx** (10s) - Configures advanced Docker builder
5. **Build and Push Docker Image** (3-5 minutes) - Multi-stage build and push

**Multi-stage Build Process:**
- **Builder stage**: Installs dependencies, builds React app
- **Production stage**: Copies built files to Nginx
- **Pushes to registry**: Multiple tags for version tracking

**Outputs:**
- ✅ Optimized Docker image (~50MB)
- ✅ Multi-tagged images in registry
- ✅ Ready for deployment

#### Stage 4: Deploy to Staging 🚀
**Purpose**: Deploy to staging environment (develop branch only)

**Steps:**
1. **Checkout Code** (2s) - Downloads source code
2. **Setup kubectl** (10s) - Installs Kubernetes CLI
3. **Configure kubectl** (5s) - Sets up kubeconfig from GitHub secrets
4. **Deploy to Staging** (30s) - Updates deployment with rolling update
5. **Verify Deployment** (10s) - Checks pods, services, and ingress

**Outputs:**
- ✅ Updated staging deployment
- ✅ Application available at `staging.aidconnect.com`
- ✅ Health checks passing

#### Stage 5: Deploy to Production 🌟
**Purpose**: Deploy to production environment (main branch only)

**Steps:**
1. **Checkout Code** (2s) - Downloads source code
2. **Setup kubectl** (10s) - Installs Kubernetes CLI
3. **Configure kubectl** (5s) - Sets up production cluster access
4. **Deploy to Production** (30s) - Rolling update with zero downtime
5. **Verify Deployment** (10s) - Confirms all components and auto-scaling

**Outputs:**
- ✅ Production deployment updated
- ✅ Application available at `aidconnect.com`
- ✅ Auto-scaling and monitoring active

### Pipeline Flow Diagram
```
Push Code
    ↓
┌─────────────┐    ┌─────────────┐
│   Test Job  │    │Security Job │
│   (2 min)   │    │   (1 min)   │
└─────────────┘    └─────────────┘
    ↓                   ↓
┌─────────────────────────────────┐
│     Build and Push Job          │
│       (3-5 minutes)             │
└─────────────────────────────────┘
    ↓
┌─────────────┬─────────────────┐
│Staging Deploy│Production Deploy│
│ (develop)   │   (main only)   │
│  (1 min)    │    (1 min)      │
└─────────────┴─────────────────┘
```

### Timeline Summary
- **Develop Branch**: 5-8 minutes total
- **Main Branch**: 5-8 minutes total
- **Pull Request**: 3-4 minutes (no deployment)

### Success Criteria
- ✅ **All green checkmarks** in GitHub Actions
- ✅ **Docker image** in GitHub Container Registry
- ✅ **Security report** in GitHub Security tab
- ✅ **Staging app** at `staging.aidconnect.com`
- ✅ **Production app** at `aidconnect.com`

### Key Technologies Used
- **CI/CD**: GitHub Actions, Ubuntu Runners
- **Build**: Node.js 20, npm, Docker Buildx
- **Security**: Trivy, CodeQL, SARIF
- **Deployment**: Kubernetes, kubectl, NGINX Ingress, cert-manager

### Benefits Achieved
- ✅ **Zero-touch deployments**
- ✅ **Automated testing and security scanning**
- ✅ **Rolling deployments with health checks**
- ✅ **Auto-scaling and monitoring**
- ✅ **Pipeline visibility and tracking**

## �🐳 Docker Setup

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
