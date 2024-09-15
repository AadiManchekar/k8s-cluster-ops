variable "aws_region" {
  description = "Default AWS Region for EKS cluster"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Base name for the cluster"
  default     = "nutella"
}

variable "instance_type" {
  description = "Instance type for EKS nodes"
  type        = string
  default     = "t2.micro"
}
