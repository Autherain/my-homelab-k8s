# Infrastructure

This directory contains the ArgoCD infrastructure setup for the homelab.

## What This Setup Does

We use ArgoCD's "App of Apps" pattern to manage infrastructure. ArgoCD watches this Git repository and automatically deploys any applications we define here.

## Directory Structure

```
infrastructure/
├── bootstrap/          # Files you apply manually once
│   ├── infrastructure.yaml        # ArgoCD project (defines permissions)
│   └── infrastructure-apps.yaml   # Root app that watches argocd-apps/
└── argocd-apps/        # Applications ArgoCD automatically deploys
    └── longhorn.yaml   # Longhorn storage system
```

## How It Works

1. **infrastructure.yaml** creates an ArgoCD project with permissions to deploy cluster resources
2. **infrastructure-apps.yaml** tells ArgoCD to watch the `argocd-apps/` folder
3. Any YAML files in `argocd-apps/` get automatically deployed by ArgoCD
4. Currently deploys Longhorn (distributed storage) to `longhorn-system` namespace

## Bootstrap Commands

Run these commands once to set up the infrastructure:

```bash
# Apply the ArgoCD project (defines permissions)
kubectl apply -f infrastructure/bootstrap/infrastructure.yaml

# Apply the root App of Apps (starts watching argocd-apps/)
kubectl apply -f infrastructure/bootstrap/infrastructure-apps.yaml

# Check status
kubectl get applications -n argocd
```

## What Was Fixed

The original issue was permission errors. ArgoCD couldn't deploy Longhorn because the infrastructure project was too restrictive. We fixed this by adding:
- `clusterResourceWhitelist: [{group: '*', kind: '*'}]` - allows all cluster resources
- `namespaceResourceWhitelist: [{group: '*', kind: '*'}]` - allows all namespace resources
- `namespace: '*'` destination - allows deployment to any namespace

## To Add New Apps

1. Create a new YAML file in `argocd-apps/`
2. Commit and push to Git
3. ArgoCD automatically deploys it

## Current Status

- **infrastructure-apps**: Synced ✅ (watches the argocd-apps folder)
- **longhorn**: Synced ✅ (storage system running in longhorn-system namespace)
