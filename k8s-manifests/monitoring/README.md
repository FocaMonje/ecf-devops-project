# Stack EFK - Monitoring

Stack de monitoring avec Elasticsearch, Fluentd et Kibana pour centraliser et visualiser les logs du cluster Kubernetes.

## Architecture
```
Applications (infoline namespace)
    ↓ logs
Fluentd DaemonSet (sur chaque node)
    ↓ collecte et envoie
Elasticsearch (stockage)
    ↓ indexation
Kibana (visualisation)
    ↓
Dashboard web
```

## Composants

### Elasticsearch
- **Type:** StatefulSet
- **Replicas:** 1 (single-node)
- **Storage:** 10Gi PVC (gp2)
- **Ports:** 9200 (HTTP), 9300 (transport)
- **Resources:** 
  - Requests: 1Gi RAM, 500m CPU
  - Limits: 2Gi RAM, 1000m CPU

### Fluentd
- **Type:** DaemonSet (un pod par node)
- **RBAC:** ServiceAccount avec permissions lecture pods/namespaces
- **ConfigMap:** Configuration de collecte et envoi
- **Sources:** Logs des containers (/var/log/containers/*.log)
- **Destination:** Elasticsearch
- **Resources:**
  - Requests: 200Mi RAM, 100m CPU
  - Limits: 512Mi RAM, 500m CPU

### Kibana
- **Type:** Deployment
- **Replicas:** 1
- **Service:** LoadBalancer (accès externe)
- **Port:** 5601
- **Resources:**
  - Requests: 512Mi RAM, 500m CPU
  - Limits: 1Gi RAM, 1000m CPU

## Déploiement

### Prérequis
- Cluster EKS opérationnel
- kubectl configuré
- Applications InfoLine déployées

### 1. Créer le namespace
```bash
kubectl apply -f namespace.yaml
```

### 2. Déployer Elasticsearch
```bash
kubectl apply -f elasticsearch/elasticsearch-service.yaml
kubectl apply -f elasticsearch/elasticsearch-statefulset.yaml

# Vérifier
kubectl get pods -n monitoring
kubectl logs -f elasticsearch-0 -n monitoring
```

Attendre que Elasticsearch soit Ready (~2-3 minutes).

### 3. Déployer Fluentd
```bash
kubectl apply -f fluentd/fluentd-rbac.yaml
kubectl apply -f fluentd/fluentd-configmap.yaml
kubectl apply -f fluentd/fluentd-daemonset.yaml

# Vérifier
kubectl get daemonset -n monitoring
kubectl get pods -n monitoring -l app=fluentd
```

### 4. Déployer Kibana
```bash
kubectl apply -f kibana/kibana-deployment.yaml
kubectl apply -f kibana/kibana-service.yaml

# Vérifier
kubectl get pods -n monitoring -l app=kibana
kubectl get svc -n monitoring kibana
```

### Déploiement complet
```bash
# Tout en une commande
kubectl apply -f namespace.yaml
kubectl apply -f elasticsearch/
kubectl apply -f fluentd/
kubectl apply -f kibana/

# Attendre que tout soit ready
kubectl wait --for=condition=ready pod -l app=elasticsearch -n monitoring --timeout=300s
kubectl wait --for=condition=ready pod -l app=kibana -n monitoring --timeout=300s
```

## Accès à Kibana

### Obtenir l'URL
```bash
# Si LoadBalancer
kubectl get svc kibana -n monitoring
# Utiliser EXTERNAL-IP:5601

# Ou port-forward pour test local
kubectl port-forward -n monitoring svc/kibana 5601:5601
# Accéder à http://localhost:5601
```

### Configuration initiale

1. Ouvrir Kibana dans le navigateur
2. Aller dans **Management** → **Index Patterns**
3. Créer un index pattern: `infoline-*`
4. Sélectionner **@timestamp** comme Time Field
5. Aller dans **Discover** pour voir les logs

## Utilisation

### Visualiser les logs

1. **Discover:** Voir tous les logs en temps réel
2. **Filtres:**
   - `kubernetes.namespace_name: "infoline"` - Logs de l'app
   - `kubernetes.container_name: "infoline-api"` - Logs API
   - `kubernetes.container_name: "infoline-frontend"` - Logs frontend

### Requêtes utiles
```
# Erreurs seulement
log: "ERROR" OR log: "Exception"

# API Spring Boot
kubernetes.container_name: "infoline-api" AND log: "RestController"

# Requêtes HTTP
log: "GET" OR log: "POST"

# Par namespace
kubernetes.namespace_name: "infoline"
```

### Créer un Dashboard

1. Aller dans **Dashboard** → **Create Dashboard**
2. Ajouter visualizations:
   - Logs par namespace
   - Erreurs au fil du temps
   - Top containers par logs
   - Requêtes HTTP par endpoint

## Monitoring

### Vérifier le statut
```bash
# Tous les pods monitoring
kubectl get pods -n monitoring

# Logs Elasticsearch
kubectl logs -f elasticsearch-0 -n monitoring

# Logs Fluentd (d'un pod)
kubectl logs -f fluentd-xxxxx -n monitoring

# Logs Kibana
kubectl logs -f deployment/kibana -n monitoring
```

### Vérifier la collecte
```bash
# Nombre de documents dans Elasticsearch
kubectl exec -it elasticsearch-0 -n monitoring -- curl -X GET "localhost:9200/_cat/indices?v"

# Index créés
kubectl exec -it elasticsearch-0 -n monitoring -- curl -X GET "localhost:9200/_cat/indices/infoline*?v"
```

### Health checks
```bash
# Elasticsearch health
kubectl exec -it elasticsearch-0 -n monitoring -- curl -X GET "localhost:9200/_cluster/health?pretty"

# Kibana status
kubectl exec -it deployment/kibana -n monitoring -- curl -X GET "localhost:5601/api/status"
```

## Troubleshooting

### Elasticsearch ne démarre pas
```bash
# Vérifier les logs
kubectl logs -f elasticsearch-0 -n monitoring

# Vérifier le PVC
kubectl get pvc -n monitoring

# Problème mémoire: ajuster ES_JAVA_OPTS dans le StatefulSet
```

### Fluentd ne collecte pas les logs
```bash
# Vérifier RBAC
kubectl get serviceaccount fluentd -n monitoring
kubectl get clusterrolebinding fluentd

# Vérifier les logs Fluentd
kubectl logs -f daemonset/fluentd -n monitoring

# Vérifier la config
kubectl describe configmap fluentd-config -n monitoring
```

### Kibana inaccessible
```bash
# Vérifier le pod
kubectl get pods -n monitoring -l app=kibana
kubectl logs -f deployment/kibana -n monitoring

# Vérifier le service
kubectl get svc kibana -n monitoring

# Port-forward pour debug
kubectl port-forward -n monitoring svc/kibana 5601:5601
```

### Pas de logs dans Kibana

1. Vérifier que Fluentd collecte:
```bash
   kubectl logs -f daemonset/fluentd -n monitoring | grep "sent"
```

2. Vérifier les index Elasticsearch:
```bash
   kubectl exec -it elasticsearch-0 -n monitoring -- curl "localhost:9200/_cat/indices?v"
```

3. Recréer l'index pattern dans Kibana:
   - Management → Index Patterns → Delete `infoline-*`
   - Créer nouveau pattern

## Scaling

### Scaler Kibana
```bash
kubectl scale deployment kibana -n monitoring --replicas=2
```

### Elasticsearch clustering (production)

Pour production, modifier le StatefulSet:
- `replicas: 3`
- `discovery.type: multi-node`
- Configurer `cluster.name` et `discovery.seed_hosts`

## Nettoyage

### Supprimer le stack EFK
```bash
kubectl delete -f kibana/
kubectl delete -f fluentd/
kubectl delete -f elasticsearch/
kubectl delete -f namespace.yaml
```

### Supprimer uniquement les déploiements (garder les données)
```bash
kubectl delete deployment kibana -n monitoring
kubectl delete daemonset fluentd -n monitoring
kubectl delete statefulset elasticsearch -n monitoring
# PVC reste pour récupération ultérieure
```

## Resources

- [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Fluentd Documentation](https://docs.fluentd.org/)
- [Kibana Documentation](https://www.elastic.co/guide/en/kibana/current/index.html)
- [EFK on Kubernetes](https://kubernetes.io/docs/tasks/debug-application-cluster/logging-elasticsearch-kibana/)
