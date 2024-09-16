resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

/*
References: 
1. https://aws.github.io/aws-eks-best-practices/networking/subnets/
2. https://repost.aws/knowledge-center/eks-vpc-subnet-discovery
*/

# two private subnets in two AZs
resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = local.availability_zones[0]

  tags = {
    "Name"                                      = "${var.cluster_name}-private-${local.availability_zones[0]}"
    "kubernetes.io/role/internal-elb"           = "1" 
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = local.availability_zones[1]

  tags = {
    "Name"                                      = "${var.cluster_name}-private-${local.availability_zones[1]}"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# two public subnets in two AZs
resource "aws_subnet" "public_zone1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = local.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "${var.cluster_name}-public-${local.availability_zones[0]}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = local.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "${var.cluster_name}-public-${local.availability_zones[1]}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

