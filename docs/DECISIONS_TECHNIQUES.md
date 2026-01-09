Décisions Techniques - Projet ECF DevOps


 Décision: WSL2 au lieu d'une Machine Virtuelle Debian


La Décision


Utiliser WSL2 (Windows Subsystem for Linux) dans mon environnement Windows 11 au lieu d'une machine virtuelle Debian complète.


Justification


J'avais déjà tous les outils installés et configurés sous Windows (Git, VSCode, Docker Desktop). Au lieu de dupliquer l'effort en tout réinstallant dans une VM Debian, j'ai opté pour WSL2 car je ne veux pas installer tout de nouveau.


Configuration Technique


    • OS Hôte: Windows 11

 
    • Version WSL: WSL2

 
    • Distribution: Ubuntu 22.04

 
    • Docker: Docker Desktop avec intégration WSL2

 
    • IDE: VSCode avec extension Remote-WSL

 

 Structure du Projet


Justification de la Structure


Séparation par Activité Technique (AT):


L'ECF est divisé en 3 activités techniques. La structure reflète cette division pour faciliter l'évaluation et le développement incrémental.


terraform/ - Séparation EKS et Lambda:


Bien que les deux soient de l'infrastructure AWS, je les garde séparés car :


    • Ils ont des cycles de vie différents (le cluster persiste, Lambda peut être recréé facilement)

 
    • Variables et configurations différentes

 
    • Facilite le terraform destroy sélectif (je peux supprimer Lambda sans toucher au cluster)

 
    • Meilleure organisation du code

 
monitoring/ séparé de k8s-manifests/:


Le stack de monitoring (EFK) est une infrastructure transversale qui surveille TOUTES les applications. Il n'appartient pas à une application spécifique, c'est pourquoi il a son propre dossier.


scripts/ pour l'automatisation:


Tous les scripts d'initialisation, de déploiement et d'utilitaires dans un seul endroit. Inclut le script qui a généré cette structure initiale.


docs/ pour la documentation:


Documentation technique, sorties de commandes. Tout ce qui est nécessaire pour la remise de l'ECF.



 Choix des Technologies


Terraform (Infrastructure as Code)


Pourquoi Terraform et non CloudFormation ou AWS CDK:


✅ Multi-cloud: Bien que j'utilise AWS maintenant, Terraform me permet de changer de fournisseur si nécessaire


✅ Déclaratif: Je décris l'état souhaité, Terraform calcule les changements nécessaires


✅ Gestion d'état: Le fichier d'état permet de savoir exactement ce qui est déployé


✅ Modules réutilisables: Je peux utiliser des modules de la communauté (comme le module EKS)


✅ Plan avant d'appliquer: Je peux voir les changements avant de les exécuter


Version: Terraform 1.14+


Kubernetes: EKS vs ECS


Pourquoi Kubernetes (EKS) et non ECS:


✅ Standard de l'industrie: Compétences transférables à n'importe quelle entreprise


✅ Écosystème riche: Helm, Operators, outils de monitoring


✅ Multi-cloud: Pourrait migrer vers GKE ou AKS si nécessaire


Stack EFK (Elasticsearch + Fluentd + Kibana)


Pourquoi EFK et non CloudWatch Logs:


✅ Centralisation: Tous les logs dans un seul endroit


✅ Recherches avancées: KQL (Kibana Query Language) est très puissant


✅ Visualisations: Dashboards personnalisés dans Kibana


✅ Open Source: Pas de dépendance à un fournisseur spécifique


✅ Agrégation: Fluentd enrichit les logs avec des métadonnées Kubernetes


Pourquoi Fluentd et non Logstash:


Fluentd est plus léger et optimisé pour Kubernetes. Logstash consomme plus de ressources.


CI/CD: GitHub Actions


Pourquoi GitHub Actions:


✅ Intégration native: Le code est déjà sur GitHub


✅ Gratuit: Pour les dépôts publics/privés (avec limites généreuses)


✅ Configuration facile: YAML simple et direct


✅ Écosystème: Milliers d'Actions disponibles sur le marketplace



Les autres technologies ont été choisies car elles sont requises par l'ECF.



 Script d'Initialisation


Motivation


Créer manuellement tous les dossiers, fichiers, README, .gitignore, etc. est fastidieux et sujet aux erreurs. En tant que bon DevOps, j'automatise tout ce qui se répète.


Ce que fait le script scripts/init-project.sh


    1. Vérifie l'environnement: Confirme que vous êtes dans le bon dossier

 
    2. Vérifie la documentation: S'assure que ce document existe avant de continuer

 
    3. Crée les fichiers de base:

 
        ◦ README.md complet avec informations du projet

 
        ◦ .gitignore exhaustif pour toutes les technologies

 
        ◦ Terraform placeholder pour AT 1

 
    4. Initialise Git: Crée le dépôt et configure la branche main

 
    5. Fait des commits structurés:

 
        ◦ Commit 1: Structure de base + Terraform placeholder

 
        ◦ Commit 2: Documentation technique

 
    6. Affiche les instructions: Prochaines étapes pour se connecter à GitHub

 
Avantages de l'automatisation


✅ Reproductibilité: Un autre étudiant pourrait utiliser le script et avoir la même structure


✅ Rapidité: 30 secondes vs 10-15 minutes manuellement


✅ Sans erreurs: Je n'oublie pas de créer un dossier ou un fichier


✅ Commits bien structurés: Messages clairs dès le début


✅ Documentation dès le jour 1: Je ne le laisse pas pour plus tard



 Stratégie de Commits


Philosophie


Commits petits, fréquents et descriptifs. Chaque commit doit être une unité logique de travail.


Convention de Messages


J'utilise Conventional Commits pour la clarté:


    • feat: Nouvelle fonctionnalité

 
    • fix: Correction de bug

 
    • docs: Documentation

 
    • chore: Tâches de maintenance

 
    • ci: Changements dans CI/CD

 
    • refactor: Refactorisation de code

 
Exemple:


feat(terraform): Add EKS cluster configuration



- VPC avec subnets publics/privés


- Cluster EKS version 1.27


- Managed node groups avec autoscaling


- Security groups et IAM roles



Related to: AT 1 - Infrastructure automation


Commits du Projet


Commit 1 (Vendredi): Structure de base


    • Répond à l'exercice du vendredi

 
    • Terraform placeholder présent

 
    • Base pour travailler

 
Commit 2: Documentation technique


    • Explique les décisions prises

 
    • Justifie l'architecture

 
    • Documente le processus

 
Commits suivants: Développement incrémental


    • Un commit par fonctionnalité complète

 
    • Tests inclus quand applicable

 
    • Documentation mise à jour

 

 Décisions de Sécurité


.gitignore


Pourquoi est-il si complet:


Le .gitignore inclut des patterns pour TOUTES les technologies du projet car:


✅ Prévention: Il est plus facile d'ignorer trop que pas assez


✅ Secrets: Je m'assure de NE JAMAIS uploader des credentials AWS, clés SSH, etc.


✅ Propreté: Le dépôt ne contient que le code source, pas les builds ni les dépendances


✅ Collaboration: D'autres développeurs ne uploaderont pas leurs fichiers locaux


Catégories incluses:


    • Terraform (state files, variables avec secrets)

 
    • Java/Maven (target, .class)

 
    • Node/Angular (node_modules, dist)

 
    • Docker/Kubernetes (secrets, kubeconfig)

 
    • IDEs (IntelliJ, VSCode, Eclipse)

 
    • OS (macOS, Windows, Linux)

 
    • Secrets (*.pem, *.key, .env, credentials.json)

 
Gestion des Secrets


NE PAS uploader sur Git:


    • AWS Access Keys

 
    • Terraform .tfvars avec données sensibles

 
    • Fichiers Kubeconfig

 
    • Certificats (.pem, .key)

 
    • Variables d'environnement (.env)

 
Solutions:


    • AWS Secrets Manager pour les secrets en production

 
    • Variables d'environnement locales

 
    • .tfvars.example avec valeurs d'exemple (sans données réelles)

 

 Développement Incrémental


Le projet sera développé dans l'ordre des activités techniques:


AT 1 - Infrastructure Cloud


    • Implémenter Terraform pour EKS (VPC, cluster, node groups)

 
    • Implémenter Terraform pour Lambda (fonction, API Gateway)

 
    • Déployer et vérifier l'infrastructure

 
AT 2 - Applications et CI/CD


    • Développer API REST Java Spring Boot

 
    • Dockeriser l'application

 
    • Créer manifestes Kubernetes et déployer sur EKS

 
    • Développer frontend Angular

 
    • Configurer pipelines GitHub Actions avec tests automatisés

 
AT 3 - Monitoring


    • Déployer stack EFK (Elasticsearch, Fluentd, Kibana)

 
    • Configurer collecte de logs

 
    • Créer queries et dashboards dans Kibana

 
Documentation finale


    • Compléter toute la documentation

 
    • Vérifier que tous les livrables sont prêts

 
    • Préparer la remise

 

 Références


Documentation Officielle


    • Terraform AWS Provider

 
    • Kubernetes Documentation

 
    • Spring Boot Guides

 
    • Angular Documentation

 
    • Elasticsearch Guide

 
Ressources Utiles


    • AWS EKS Best Practices

 
    • Terraform Best Practices

 
    • Conventional Commits

 

Notes Finales


Ce document justifie toutes les décisions techniques prises dans le cadre de ce projet ECF.


