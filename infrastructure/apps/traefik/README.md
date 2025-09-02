# Traefik Configuration with Helm + Kustomize

This directory contains a complete Traefik configuration using Kustomize with Helm charts, middleware, secrets, and patches.

## Structure

```
traefik/
├── middleware/          # Traefik middleware configurations
│   ├── basic-auth.yaml
│   ├── rate-limit.yaml
│   ├── cors.yaml
│   └── security-headers.yaml
├── secrets/             # Kubernetes secrets
│   ├── basic-auth-secret.yaml
│   └── tls-secret.yaml
├── patches/             # Patches for Helm-generated resources
│   ├── service-patch.yaml
│   └── deployment-patch.yaml
├── kustomization.yaml   # Kustomize configuration with Helm charts
└── README.md           # This file
```

## Middleware Types

### 1. Basic Authentication

- **File**: `middleware/basic-auth.yaml`
- **Purpose**: Adds HTTP basic authentication to routes
- **Usage**: Reference in IngressRoute or Ingress annotations

### 2. Rate Limiting

- **File**: `middleware/rate-limit.yaml`
- **Purpose**: Limits the number of requests per time period
- **Usage**: Apply to APIs or web applications

### 3. CORS

- **File**: `middleware/cors.yaml`
- **Purpose**: Handles Cross-Origin Resource Sharing
- **Usage**: Apply to web applications that need to handle cross-origin requests

### 4. Security Headers

- **File**: `middleware/security-headers.yaml`
- **Purpose**: Adds security headers to responses
- **Usage**: Apply to web applications for enhanced security

## Secrets

### 1. Basic Auth Secret

- **File**: `secrets/basic-auth-secret.yaml`
- **Purpose**: Stores username/password pairs for basic auth
- **Note**: Update the `users` field with your actual htpasswd output

### 2. TLS Secret

- **File**: `secrets/tls-secret.yaml`
- **Purpose**: Stores TLS certificates and private keys
- **Note**: Update with your actual base64-encoded certificate and key

## Usage Examples

### Using Middleware in IngressRoute

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: my-app
  namespace: default
spec:
  entryPoints:
    - web
  routes:
    - match: Host(`myapp.example.com`)
      kind: Rule
      services:
        - name: my-app-service
          port: 80
      middlewares:
        - name: basic-auth
          namespace: traefik
        - name: security-headers
          namespace: traefik
```

### Using Middleware in Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  namespace: default
  annotations:
    traefik.ingress.kubernetes.io/router.middlewares: traefik-basic-auth@kubernetescrd,traefik-security-headers@kubernetescrd
spec:
  rules:
    - host: myapp.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app-service
                port:
                  number: 80
```

## Deployment

This configuration is deployed via ArgoCD using the `traeffik-application`. The setup combines:

1. **Helm Chart**: Traefik 37.0.0 from the official repository
2. **Kustomize Resources**: Middleware and secrets as separate Kubernetes resources
3. **Patches**: Custom modifications to Helm-generated resources
4. **Single Application**: Everything managed in one ArgoCD application

The application is configured to:

- Deploy with sync-wave: 2
- Automatically sync changes
- Prune removed resources

## Customization

1. **Update secrets**: Modify the secret files with your actual values
2. **Add new middleware**: Create new YAML files in the `middleware/` directory
3. **Add new secrets**: Create new YAML files in the `secrets/` directory
4. **Update kustomization.yaml**: Add new resources to the resources list

## Security Notes

- Never commit actual secrets to version control
- Use external secret management solutions for production
- Consider using Sealed Secrets or External Secrets Operator
- Rotate secrets regularly
