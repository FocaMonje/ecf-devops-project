# Kubernetes Manifests - InfoLine

Manifestes Kubernetes pour déployer l'application InfoLine sur AWS EKS.

## Structure
```
k8s-manifests/
├── namespace/
│   └── namespace.yaml           # Namespace infoline
├── postgres/
│   ├── postgres-secret.yaml     # Credentials DB
│   ├── postgres-pvc.yaml        # Persistent storage
│   ├── postgres-deployment.yaml # PostgreSQL pod
│   └── postgres-service.yaml    # Service interne
├── spring-boot/
│   ├── api-configmap.yaml       # Configuration API
│   ├── api-secret.yaml          # Credentials API
│   ├── api-deployment.yaml      # Spring Boot pods
│   └── api-service.yaml         # Service interne
├── angular/
│   ├── frontend-configmap.yaml  # Configuration Nginx
│   ├── frontend-deployment.yaml # Angular pods
│   └── frontend-service.yaml    # Service interne
└── ingress.yaml                 # ALB Ingress Controller
```

## Prérequis

- Cluster EKS configuré et running
- kubectl configuré pour accéder au cluster
- AWS ALB Ingress Controller installé
- Images Docker disponibles:
  - `infoline-api:1.0.0`
  - `infoline-frontend:1.0.0`

## Déploiement

### 1. Créer le namespace
```bash
kubectl apply -f namespace/namespace.yaml
```

### 2. Déployer PostgreSQL
```bash
kubectl apply -f postgres/postgres-secret.yaml
kubectl apply -f postgres/postgres-pvc.yaml
kubectl apply -f postgres/postgres-deployment.yaml
kubectl apply -f postgres/postgres-service.yaml

# Vérifier
kubectl get pods -n infoline
kubectl get pvc -n infoline
```

### 3. Déployer l'API Spring Boot
```bash
kubectl apply -f spring-boot/api-configmap.yaml
kubectl apply -f spring-boot/api-secret.yaml
kubectl apply -f spring-boot/api-deployment.yaml
kubectl apply -f spring-boot/api-service.yaml

# Vérifier
kubectl get pods -n infoline
kubectl logs -f deployment/infoline-api -n infoline
```

### 4. Déployer le Frontend Angular
```bash
kubectl apply -f angular/frontend-configmap.yaml
kubectl apply -f angular/frontend-deployment.yaml
kubectl apply -f angular/frontend-service.yaml

# Vérifier
kubectl get pods -n infoline
```

### 5. Déployer l'Ingress
```bash
kubectl apply -f ingress.yaml

# Obtenir l'URL du Load Balancer
kubectl get ingress -n infoline
# Attendre quelques minutes que l'ALB soit provisionné
```

### Déploiement complet en une commande
```bash
kubectl apply -f namespace/
kubectl apply -f postgres/
kubectl apply -f spring-boot/
kubectl apply -f angular/
kubectl apply -f ingress.yaml
```

## Vérification

### Vérifier les pods
```bash
kubectl get pods -n infoline

# Devrait afficher:
# NAME                                  READY   STATUS    RESTARTS   AGE
# postgres-xxx                          1/1     Running   0          2m
# infoline-api-xxx                      1/1     Running   0          1m
# infoline-api-yyy                      1/1     Running   0          1m
# infoline-frontend-xxx                 1/1     Running   0          1m
# infoline-frontend-yyy                 1/1     Running   0          1m
```

### Vérifier les services
```bash
kubectl get svc -n infoline
```

### Vérifier l'ingress
```bash
kubectl get ingress -n infoline
kubectl describe ingress infoline-ingress -n infoline
```

### Logs
```bash
# API
kubectl logs -f deployment/infoline-api -n infoline

# Frontend
kubectl logs -f deployment/infoline-frontend -n infoline

# PostgreSQL
kubectl logs -f deployment/postgres -n infoline
```

## Accès à l'application

Une fois l'Ingress déployé, récupérer l'URL:
```bash
kubectl get ingress infoline-ingress -n infoline -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Accéder à:
- Frontend: `http://<ALB-URL>/`
- API: `http://<ALB-URL>/api/health`

## Scaling

### Scaler l'API
```bash
kubectl scale deployment infoline-api -n infoline --replicas=3
```

### Scaler le Frontend
```bash
kubectl scale deployment infoline-frontend -n infoline --replicas=3
```

## Mise à jour

### Mettre à jour une image
```bash
kubectl set image deployment/infoline-api infoline-api=infoline-api:2.0.0 -n infoline
kubectl rollout status deployment/infoline-api -n infoline
```

### Rollback
```bash
kubectl rollout undo deployment/infoline-api -n infoline
```

## Nettoyage

### Supprimer l'application
```bash
kubectl delete -f ingress.yaml
kubectl delete -f angular/
kubectl delete -f spring-boot/
kubectl delete -f postgres/
kubectl delete -f namespace/
```

### Supprimer uniquement les déploiements (garder les données)
```bash
kubectl delete -f ingress.yaml
kubectl delete -f angular/frontend-deployment.yaml
kubectl delete -f spring-boot/api-deployment.yaml
kubectl delete -f postgres/postgres-deployment.yaml
# Les PVC et Secrets restent
```

## Troubleshooting

### Pod ne démarre pas
```bash
kubectl describe pod <pod-name> -n infoline
kubectl logs <pod-name> -n infoline
```

### Service non accessible
```bash
kubectl get endpoints -n infoline
kubectl describe service <service-name> -n infoline
```

### Problèmes de connexion DB
```bash
# Tester la connexion depuis l'API pod
kubectl exec -it <api-pod-name> -n infoline -- curl postgres-service:5432
```

### Problèmes Ingress
```bash
kubectl describe ingress infoline-ingress -n infoline
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```

## Ressources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
