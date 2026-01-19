# ECF - Administrateur Système DevOps

## Contexte du projet

**Client:** InfoLine  
**Secteur:** Actualités technologiques dans le domaine du sport  
**Objectif:** Infrastructure cloud évolutive pour plateforme de commerce électronique

### Description d'InfoLine

InfoLine est une nouvelle agence qui cherche à se démarquer sur le marché de l'actualité technologique dans le domaine du sport. Elle a besoin d'un site web qui permette :

- Afficher les actualités sur les produits sportifs connectés
- Promotion et vente de produits
- Gestion des utilisateurs (visiteurs et inscrits)
- Backoffice pour administrateurs

### Architecture de la solution

**Applications :**
- API REST en Java Spring Boot (dockerisée dans Kubernetes)
- Fonction Java pour l'authentification dans AWS Lambda (sans serveur)
- Frontend principal dans Angular
- Frontend backoffice dans Angular  
- Base de données PostgreSQL

**Infrastructure :**
- Cloud: AWS
- IaC: Terraform
- Orchestration: Kubernetes (EKS)
- Monitoring: Stack EFK

---

## Activités techniques de l'ECF

### AT 1 : Automatisation de l'infrastructure cloud
Préparer l'infrastructure grâce à Infrastructure as Code:
- [x] Structure du projet créée
- [ ] Cluster Kubernetes (AWS EKS) avec Terraform
- [ ] Service sans serveur (AWS Lambda) avec Terraform
- [ ] Networking et sécurité configurés

### AT 2 : Déploiement continu des applications
Mettre en œuvre CI/CD pour les applications :
- [ ] Application Java Spring Boot (Hello World)
- [ ] Dockerisation de Spring Boot
- [ ] Script de build/test/deploy
- [ ] Application Angular (Hello World)
- [ ] Pipeline CI/CD (GitHub Actions/CircleCI)

### AT 3 : Supervision des services
Mettre en place un suivi complet :
- [ ] Elasticsearch déployé sur Kubernetes
- [ ] Fluentd collectant logs
- [ ] Kibana connecté à Elasticsearch
- [ ] Queries et dashboards documentés

---

## Structure du projet

```
ecf-devops-project/
├── terraform/              # Infrastructure as Code
│   ├── eks-cluster/       # Cluster Kubernetes (AT 1)
│   │   ├── main.tf        # Configuration principale
│   │   ├── variables.tf   # Variables
│   │   └── outputs.tf     # Outputs
│   └── lambda/            # Fonction Serverless (AT 1)
│       ├── main.tf
│       ├── lambda_function.py
│       └── outputs.tf
├── spring-boot-app/       # API Java (AT 2)
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile
│   └── deploy.sh
├── angular-hello-world/   # Frontend (AT 2)
│   ├── src/
│   ├── angular.json
│   └── package.json
├── monitoring/            # Stack EFK (AT 3)
│   ├── elasticsearch.yaml
│   ├── fluentd-config.yaml
│   ├── fluentd-daemonset.yaml
│   ├── kibana.yaml
│   └── deploy-monitoring.sh
├── k8s-manifests/        # Manifestes Kubernetes
│   └── spring-boot-deployment.yaml
├── scripts/              # Scripts d'automatisation
│   └── init-project.sh   # Ce script
├── docs/                 # Documentation technique
│   └── DECISIONS_TECHNIQUES.md
└── .github/
    └── workflows/        # Pipelines CI/CD
        └── angular-ci.yml
```

---

## Stack Technologique

### Infrastructure
- **Cloud:** AWS
- **IaC:** Terraform 1.14+
- **Kubernetes:** AWS EKS 1.27
- **Serverless:** AWS Lambda + API Gateway

### Applications
- **Backend:** Java 17 + Spring Boot 3.2 + Maven
- **Frontend:** Angular 17 + TypeScript + npm
- **Conteneurs:** Docker
- **Orchestration:** Kubernetes

### DevOps
- **VCS:** Git + GitHub
- **CI/CD:** GitHub Actions / CircleCI
- **Registry:** Docker Hub / AWS ECR
- **Monitoring:** Elasticsearch + Fluentd + Kibana

---

## Guide d'utilisation

### Prérequis

Outils installés :
- [x] WSL2 avec Ubuntu 22.04
- [x] Docker Desktop
- [x] Git configuré
- [x] AWS CLI
- [x] Terraform
- [x] kubectl
- [x] Java 17 + Maven
- [x] Node.js 18 + Angular CLI

### Configuration initiale

```bash
# 1. Cloner le dépôt
git clone https://github.com/FocaMonje/ecf-devops-project.git
cd ecf-devops-project

# 2. Configurer AWS
aws configure
# Entrer Access Key ID et Secret Access Key

# 3. Vérifier les outils
./scripts/check-tools.sh
```

### Déploiement de l'infrastructure

```bash
# EKS Cluster
cd terraform/eks-cluster
terraform init
terraform plan
terraform apply

# Lambda Function
cd ../lambda
terraform init
terraform apply
```

### Déploiement d'applications

```bash
# Spring Boot
cd spring-boot-app
./deploy.sh

# Angular
cd angular-hello-world
npm install
npm run build
```

### Monitoring

```bash
cd monitoring
./deploy-monitoring.sh
```

---

## Documentation

- **[Decisions Techniques](docs/DECISIONS_TECHNIQUES.md)** - Justification des décisions architecturales

---

## Liens utiles

### AWS & Terraform
- [AWS Console](https://console.aws.amazon.com/)
- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)

### Développement
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Angular Documentation](https://angular.io/docs)
- [Docker Documentation](https://docs.docker.com/)

### Kubernetes & Monitoring
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Elastic Stack Documentation](https://www.elastic.co/guide/index.html)

---

> *"L’automatisation est un principe fondamental de DevOps."*
