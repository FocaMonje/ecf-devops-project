# InfoLine API

API REST pour la gestion des employés et départements d'InfoLine.

## Technologies

- Java 17
- Spring Boot 3.2.1
- Spring Data JPA
- PostgreSQL
- Maven
- Docker

## Endpoints

### Départements

- `GET /api/departements` - Liste tous les départements
- `GET /api/departements/{id}` - Récupère un département par ID
- `POST /api/departements` - Crée un nouveau département
- `PUT /api/departements/{id}` - Met à jour un département
- `DELETE /api/departements/{id}` - Supprime un département

### Employés

- `GET /api/employes` - Liste tous les employés
- `GET /api/employes/{id}` - Récupère un employé par ID
- `GET /api/employes/departement/{departementId}` - Liste les employés d'un département
- `POST /api/employes` - Crée un nouvel employé
- `PUT /api/employes/{id}` - Met à jour un employé
- `DELETE /api/employes/{id}` - Supprime un employé

### Health

- `GET /api/health` - Statut de l'application
- `GET /api/hello` - Test simple

## Développement Local

### Prérequis

- Java 17
- Maven 3.9+
- Docker et Docker Compose

### Démarrer avec Docker Compose
```bash
# Construire et démarrer
docker-compose up --build

# L'API sera disponible sur http://localhost:8080
```

### Démarrer sans Docker
```bash
# Avec Maven
mvn spring-boot:run

# Ou compiler et exécuter
mvn clean package
java -jar target/infoline-api-1.0.0.jar
```

## Tests

### Tester l'API
```bash
# Health check
curl http://localhost:8080/api/health

# Hello
curl http://localhost:8080/api/hello

# Liste des départements
curl http://localhost:8080/api/departements

# Créer un département
curl -X POST http://localhost:8080/api/departements \
  -H "Content-Type: application/json" \
  -d '{"nom":"IT","description":"Département informatique"}'

# Liste des employés
curl http://localhost:8080/api/employes

# Créer un employé
curl -X POST http://localhost:8080/api/employes \
  -H "Content-Type: application/json" \
  -d '{"prenom":"Marie","nom":"Dupont","email":"marie.dupont@infoline.com","poste":"Développeuse"}'
```

## Configuration

### application.properties

Les configurations principales se trouvent dans `src/main/resources/application.properties`.

Pour la production, utiliser des variables d'environnement :
- `SPRING_DATASOURCE_URL`
- `SPRING_DATASOURCE_USERNAME`
- `SPRING_DATASOURCE_PASSWORD`

## Build Docker
```bash
# Construire l'image
docker build -t infoline-api:1.0.0 .

# Exécuter le conteneur
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/infoline \
  infoline-api:1.0.0
```

## Projet ECF DevOps

Cette API fait partie du projet ECF DevOps pour InfoLine.
