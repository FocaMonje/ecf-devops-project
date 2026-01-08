#!/bin/bash

echo "=================================================="
echo "   DÉMARRAGE DU PROJET ECF DEVOPS"
echo "=================================================="
echo ""

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier qu’on est dans le bon dossier
if [ ! -d "terraform" ]; then
    echo "ERREUR : Vous devez exécuter ce script à partir du dossier ecf-devops-project."
    echo "Exécutez : cd ~/ecf-devops-project"
    exit 1
fi

echo -e "${BLUE}Création des fichiers du projet...${NC}"
echo ""

# ============================================
# README.md
# ============================================
echo -e "${GREEN}✓${NC} Création d'un fichier README.md"
cat > README.md << 'ENDOFFILE'
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
- **[Guide de Commits](docs/COMMITS.md)** - Conventions et stratégie de commits *(à venir)*

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
ENDOFFILE

# ============================================
# .gitignore
# ============================================
echo -e "${GREEN}✓${NC} Création .gitignore"
cat > .gitignore << 'ENDOFFILE'
# ==================== TERRAFORM ====================
*.tfstate
*.tfstate.*
*.tfstate.backup
.terraform/
.terraform.lock.hcl
*.tfvars
!example.tfvars
crash.log
override.tf
override.tf.json

# ==================== JAVA / MAVEN ====================
target/
*.class
*.jar
*.war
*.ear
.mvn/
mvnw
mvnw.cmd

# ==================== SPRING BOOT ====================
.springBeans
.sts4-cache/

# ==================== NODE / ANGULAR ====================
node_modules/
dist/
npm-debug.log*
yarn-error.log*
.angular/
.sass-cache/
package-lock.json
yarn.lock

# ==================== IDE ====================
.idea/
*.iml
.vscode/
.settings/
.project
.classpath
*.swp

# ==================== OS ====================
.DS_Store
Thumbs.db
desktop.ini

# ==================== DOCKER ====================
.dockerignore

# ==================== KUBERNETES ====================
kubeconfig
*.kubeconfig

# ==================== AWS / SECRETS ====================
*.pem
*.key
*.p12
credentials.json
.env
.env.local
secrets.yml

# ==================== LOGS ====================
*.log
logs/

# ==================== DATABASE ====================
*.db
*.sqlite
*.sqlite3

# ==================== BACKUP ====================
*.bak
*.backup
*.old

# ==================== TEMPORAL ====================
temp/
tmp/
*.tmp
ENDOFFILE

# ============================================
# Terraform placeholder (pour vendredi 09-01-2026)
# ============================================
echo -e "${GREEN}✓${NC} Création terraform/eks-cluster/main.tf"
cat > terraform/eks-cluster/main.tf << 'ENDOFFILE'
# ============================================
# CONFIGURATION TERRAFORM POUR EKS
# ============================================
# Projet: ECF DevOps - InfoLine
# Activité: AT 1 - Automatisation de l'Infrastructure
# Description: Cluster Kubernetes en AWS EKS
# État: En cours de développement
# ============================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuration du provider AWS
# Région: Europe (Paris)
provider "aws" {
  region = "eu-west-3"
  
  default_tags {
    tags = {
      Project     = "ECF-DevOps-InfoLine"
      Environment = "development"
      ManagedBy   = "Terraform"
      Student     = "Maria del Carmen"
    }
  }
}

# ============================================
# VPC ET NETWORKING
# ============================================
# TODO: Mettre en œuvre VPC avec subnets publics et privés
# - 3 availability zones pour haute disponibilité
# - NAT Gateway pour subnets privés
# - Internet Gateway pour subnets publics

# ============================================
# CLUSTER EKS
# ============================================
# TODO: Mettre en œuvre cluster EKS
# - Version de Kubernetes
# - Node groups
# - Security groups
# - IAM roles

# ============================================
# OUTPUTS
# ============================================
# TODO: Exporter les informations du cluster
# - Cluster endpoint
# - Cluster name
# - Security groups
ENDOFFILE

# ============================================
# Créer un répertoire scripts et copier init script
# ============================================
echo -e "${GREEN}✓${NC} Copie du script d'initialisation"
cp "$0" scripts/init-project.sh 2>/dev/null || echo "Script existe déjà dans scripts/"

# ============================================
# Vérifier le document des décisions techniques
# ============================================
echo -e "${BLUE}Vérification de docs/DECISIONS_TECHNIQUES.md${NC}"

if [ ! -f "docs/DECISIONS_TECHNIQUES.md" ]; then
    echo ""
    echo -e "${YELLOW}ATTENTION: docs/DECISIONS_TECHNIQUES.md n'existe pas!${NC}"
    echo ""
    echo "Vous devez créer ce fichier AVANT d'exécuter le script."
    echo ""
    echo "Étapes à suivre:"
    echo "1. Téléchargez le fichier DECISIONS_TECHNIQUES.md"
    echo "2. Copiez son contenu:"
    echo "   nano docs/DECISIONS_TECHNIQUES.md"
    echo "   (Collez le contenu complet)"
    echo "   Ctrl+X, Y, Enter"
    echo "3. Relancez ce script"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓${NC} docs/DECISIONS_TECHNIQUES.md détecté et présent"

# ============================================
# INITIALISER GIT
# ============================================
echo ""
echo -e "${BLUE}Initialisation du référentiel Git...${NC}"

git init > /dev/null 2>&1
git branch -M main > /dev/null 2>&1

echo -e "${GREEN}✓${NC} Git initialisé"
echo -e "${GREEN}✓${NC} Branch principal: main"

# ============================================
# COMMIT 1: Structure de base (exercice vendredi 09-01-2026)
# ============================================
echo ""
echo -e "${BLUE}Préparation du Commit 1 : Structure de base...${NC}"

git add README.md .gitignore terraform/
git commit -m "Initial commit: Project structure with Terraform placeholder

Structure du projet ECF pour InfoLine créée:

Fichiers de base:
- README.md avec le contexte complet du projet
- .gitignore
- Structure des répertoires organisée par AT

Terraform:
- terraform/eks-cluster/main.tf (placeholder)
- Configuration du provider AWS
- Tags par défaut pour les ressources
- TODOs pour mise en œuvre future

Préparé pour:
- AT 1: Infrastructure Cloud (Terraform)
- AT 2: Applications et CI/CD
- AT 3: Monitoring (Stack EFK)

Status: Exercice vendredi fait
Suivant: Implémenter le code Terraform réel pour EKS

Related to: AT 1 - Infrastructure automation" > /dev/null 2>&1

echo -e "${GREEN}✓${NC} Commit 1 réalisé : Structure de base"

# ============================================
# COMMIT 2: Documentation technique
# ============================================
echo ""
echo -e "${BLUE}Préparation du Commit 2 : Documentation technique...${NC}"

git add scripts/ docs/
git commit -m "docs: Add technical decisions documentation and init script

Documentation technique ajoutée:

1. docs/DECISIONS_TECHNIQUES.md
   - Justification des décisions architecturales
   - Pourquoi WSL2 plutôt que VM Debian
   - Structure du projet expliquée
   - Choix technologiques justifiés
   - Stratégie de commits et sécurité

2. scripts/init-project.sh
   - Script d'initialisation automatisée
   - Crée toute la structure du projet
   - Génère des fichiers de base (README, .gitignore)
   - Effectue des commits structurés
   - Gagne du temps et évite les erreurs

Philosophie DevOps:
- Automatiser tout ce qui est répétitif
- Documenter toutes les décisions
- Commits courts et descriptifs
- Infrastructure en tant que code

Related to: Documentation et automatisation" > /dev/null 2>&1

echo -e "${GREEN}✓${NC} Commit 2 réalisé : Documentation technique"

# ============================================
# AFFICHER L'ÉTAT FINAL
# ============================================
echo ""
echo "=================================================="
echo "   PROJET DÉMARRÉ CORRECTEMENT"
echo "=================================================="
echo ""
echo -e "${BLUE}Structure du projet:${NC}"
echo ""
tree -L 2 -a 2>/dev/null || ls -la
echo ""
echo -e "${BLUE}Fichiers créés:${NC}"
echo "  ✓ README.md - Documentation du projet"
echo "  ✓ .gitignore - Ignorer les fichiers indésirables"
echo "  ✓ terraform/eks-cluster/main.tf - Terraform placeholder"
echo "  ✓ docs/DECISIONS_TECHNIQUES.md - Justifications techniques"
echo "  ✓ scripts/init-project.sh - Ce script"
echo ""
echo -e "${BLUE}Git:${NC}"
echo "  ✓ Dépôt initialisé"
echo "  ✓ Branche: main"
echo "  ✓ Commits réalisés: 2"
echo ""
git log --oneline
echo ""
