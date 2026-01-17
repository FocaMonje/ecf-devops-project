# InfoLine Frontend

Application Angular pour la gestion des employés et départements d'InfoLine.

## Technologies

- Angular 19
- TypeScript
- RxJS
- Angular Router
- HttpClient
- Nginx (production)
- Docker

## Fonctionnalités

### Gestion des Employés
- Liste des employés avec tableau
- Création d'employé
- Modification d'employé
- Suppression d'employé
- Validation des formulaires

### Gestion des Départements
- Liste des départements
- Création de département
- Modification de département
- Suppression de département

### Interface
- Navigation intuitive
- Design responsive
- Messages d'erreur clairs
- Chargement avec indicateurs
- Confirmation avant suppression

## Développement Local

### Prérequis

- Node.js 18+
- npm 10+
- Angular CLI 19

### Installation
```bash
# Installer les dépendances
npm install

# Démarrer le serveur de développement
ng serve

# L'application sera disponible sur http://localhost:4200
```

### Build
```bash
# Build de production
ng build

# Les fichiers seront dans dist/angular-hello-world/browser/
```

## Docker

### Build de l'image
```bash
# Construire l'image
docker build -t infoline-frontend:1.0.0 .

# Exécuter le conteneur
docker run -p 80:80 infoline-frontend:1.0.0

# L'application sera disponible sur http://localhost
```

### docker-compose (avec API)
```bash
# Depuis la racine du projet
docker-compose up --build

# Frontend: http://localhost:4200
# API: http://localhost:8080
```

## Structure du Projet
```
src/
├── app/
│   ├── components/          # Composants Angular
│   │   ├── home/           # Page d'accueil
│   │   ├── employe-list/   # Liste employés
│   │   ├── employe-form/   # Formulaire employé
│   │   ├── departement-list/
│   │   └── departement-form/
│   ├── services/           # Services HTTP
│   │   ├── employe.service.ts
│   │   └── departement.service.ts
│   ├── models/            # Interfaces TypeScript
│   │   ├── employe.model.ts
│   │   └── departement.model.ts
│   ├── app.component.*    # Composant principal
│   ├── app.routes.ts      # Configuration des routes
│   └── app.config.ts      # Configuration de l'app
├── assets/                # Fichiers statiques
└── styles.css            # Styles globaux
```

## Routes

- `/` - Page d'accueil
- `/employes` - Liste des employés
- `/employes/new` - Créer un employé
- `/employes/edit/:id` - Modifier un employé
- `/departements` - Liste des départements
- `/departements/new` - Créer un département
- `/departements/edit/:id` - Modifier un département

## Configuration API

L'URL de l'API est configurée dans les services :
```typescript
// src/app/services/employe.service.ts
private apiUrl = 'http://localhost:8080/api/employes';

// src/app/services/departement.service.ts
private apiUrl = 'http://localhost:8080/api/departements';
```

Pour la production, modifier ces URLs ou utiliser des variables d'environnement.

## Tests
```bash
# Tests unitaires
ng test

# Tests e2e
ng e2e
```

## Build pour Production
```bash
# Build optimisé
ng build --configuration production

# Fichiers dans dist/ prêts pour déploiement
```

## Déploiement Kubernetes

Les manifests Kubernetes se trouvent dans `/k8s-manifests/` à la racine du projet.
```bash
# Déployer sur Kubernetes
kubectl apply -f k8s-manifests/frontend/
```

## Projet ECF DevOps

Cette application fait partie du projet ECF DevOps pour InfoLine.

### Architecture complète

- **Frontend**: Angular (ce projet)
- **Backend**: Spring Boot REST API
- **Base de données**: PostgreSQL
- **Infrastructure**: AWS EKS (Kubernetes)
- **CI/CD**: GitHub Actions
- **Monitoring**: Stack EFK (Elasticsearch, Fluentd, Kibana)
