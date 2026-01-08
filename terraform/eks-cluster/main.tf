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
