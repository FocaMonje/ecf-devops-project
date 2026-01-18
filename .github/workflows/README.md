# GitHub Actions Workflows

Pipelines CI/CD pour le projet InfoLine.

## Workflows

### 1. Spring Boot CI (`spring-boot-ci.yml`)

**Trigger:**
- Push sur `main` avec changements dans `spring-boot-app/`
- Pull Request vers `main`

**Steps:**
1. Checkout code
2. Setup JDK 17
3. Build avec Maven
4. Run tests
5. Build Docker image
6. Upload artifact

**Durée:** ~3-5 minutes

---

### 2. Angular CI (`angular-ci.yml`)

**Trigger:**
- Push sur `main` avec changements dans `angular-hello-world/`
- Pull Request vers `main`

**Steps:**
1. Checkout code
2. Setup Node.js 18
3. Install dependencies (npm ci)
4. Lint (optionnel)
5. Build
6. Run tests
7. Build Docker image
8. Upload artifact

**Durée:** ~2-4 minutes

---

### 3. Terraform Validate (`terraform-validate.yml`)

**Trigger:**
- Push sur `main` avec changements dans `terraform/`
- Pull Request vers `main`

**Steps:**
1. Checkout code
2. Setup Terraform
3. Format check
4. Init (sans backend)
5. Validate

**Matrix:**
- `terraform/eks-cluster`
- `terraform/lambda`

**Durée:** ~1-2 minutes

---

### 4. Full CI Pipeline (`full-ci.yml`)

**Trigger:**
- Push sur `main`
- Pull Request vers `main`

**Jobs:**
1. Terraform Validate (EKS + Lambda)
2. Spring Boot (build + test)
3. Angular (build + test)
4. Status Check (tous les jobs réussis)

**Durée totale:** ~5-7 minutes

---

## Visualisation
```
Push to main
    ↓
┌───────────────────────────────────────┐
│         Full CI Pipeline              │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────┐                 │
│  │ Terraform       │                 │
│  │ - EKS validate  │                 │
│  │ - Lambda valid. │                 │
│  └─────────────────┘                 │
│           ↓                           │
│  ┌─────────────────┐                 │
│  │ Spring Boot     │                 │
│  │ - Maven build   │                 │
│  │ - Tests         │                 │
│  │ - Docker build  │                 │
│  └─────────────────┘                 │
│           ↓                           │
│  ┌─────────────────┐                 │
│  │ Angular         │                 │
│  │ - npm build     │                 │
│  │ - Tests         │                 │
│  │ - Docker build  │                 │
│  └─────────────────┘                 │
│           ↓                           │
│  ┌─────────────────┐                 │
│  │ ✅ All Passed   │                 │
│  └─────────────────┘                 │
│                                       │
└───────────────────────────────────────┘
```

## Badges

Ajouter au README.md principal:
```markdown
![Spring Boot CI](https://github.com/FocaMonje/ecf-devops-project/workflows/Spring%20Boot%20CI/badge.svg)
![Angular CI](https://github.com/FocaMonje/ecf-devops-project/workflows/Angular%20CI/badge.svg)
![Terraform Validate](https://github.com/FocaMonje/ecf-devops-project/workflows/Terraform%20Validate/badge.svg)
```

## Configuration Secrets (pour futur déploiement)

Pour déployer sur AWS EKS (à configurer plus tard):

1. Aller dans Settings → Secrets and variables → Actions
2. Ajouter les secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION` (eu-west-3)
   - `ECR_REPOSITORY_API`
   - `ECR_REPOSITORY_FRONTEND`

## Utilisation

### Voir les workflows

https://github.com/FocaMonje/ecf-devops-project/actions

### Re-run un workflow

1. Aller dans Actions
2. Sélectionner le workflow
3. Cliquer "Re-run jobs"

### Debugging

Si un workflow échoue:

1. Cliquer sur le workflow rouge
2. Cliquer sur le job qui a échoué
3. Lire les logs
4. Corriger le code
5. Push → workflow se relance automatiquement

## Prochaines étapes (hors scope ECF)

- [ ] Déploiement automatique sur EKS après tests
- [ ] Push images vers AWS ECR
- [ ] Notifications Slack/Discord
- [ ] Code coverage reports
- [ ] Security scanning (Snyk, Trivy)
- [ ] Performance tests
