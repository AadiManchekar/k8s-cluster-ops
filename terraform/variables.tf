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

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
  default     = [] # By Default an empty list; will be overridden by data source
}
