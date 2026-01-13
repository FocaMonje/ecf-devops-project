variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "infoline-eks-cluster"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}
