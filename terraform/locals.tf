locals {
  eks_version = 1.29
  availability_zones = data.aws_availability_zones.available.names
}
