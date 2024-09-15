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

# terraform/outputs.tf
output "vpc_name" {
  description = "Name of the VPC"
  value       = aws_vpc.main.tags["Name"]
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value = [
    aws_subnet.private_zone1.tags["Name"],
    aws_subnet.private_zone2.tags["Name"]
  ]
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of the private subnets"
  value = [
    aws_subnet.private_zone1.cidr_block,
    aws_subnet.private_zone2.cidr_block
  ]
}
