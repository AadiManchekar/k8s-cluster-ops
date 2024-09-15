output "aws_region" {
  description = "Default AWS Region for EKS cluster"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Base name for the cluster"
  value       = var.cluster_name
}

output "instance_type" {
  description = "Instance type for EKS nodes"
  value       = var.instance_type
}
