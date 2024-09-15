variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment Type (dev, qa, prod)"
  default     = "dev"
}

variable "cluster_name" {
  description = "Base name for the cluster"
  default     = "nutella"
}
