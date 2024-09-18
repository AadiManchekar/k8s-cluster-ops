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

We will use private subnet for running workloads & public subnet to deploy NLB or ALB
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

/*
We would need two (public & private) route tables
Why?
All the workloads will run in private subnet and they would need access to internet inorder to download packages etc
For which internet-bound traffic arising from private subnets (where our workloads run) will be directed towards Nat gateway which is placed in public subnet.
Nat gateway helps in handling outbound traffic while keeping the instances private.

NOTE: Internet Gateway only allows traffic for public subnets

OUTBOUND Traffic from Private Subnet to the Internet
1. Instance in Private Subnet initiates a request eg an API call
2. Private Route Table routes the outbound traffic with the destination 0.0.0.0/0 (any address on the internet) through the NAT Gateway.
3. NAT Gateway is deployed in the public subnet and has a public IP address (Elastic IP) (static ip). The NAT Gateway performs network address translation, changing the source IP of the private instance to its own public IP.
4. Internet Gateway forwards the request from the NAT Gateway to the internet.
In this way a request from private subnet is reached to internet (NOTE here the source IP will be of Nat Gatway)

Inbound Traffic from the Internet to Private 
1. Internet will respond back to source IP (which is our NAT gateway) but it first its internet gateway
2. The IGW forwards the traffic directly to the instance in the public subnet i.e to our NAT gateway
3. Nat gateway does a reverse NAT and then forwards the traffic to the desired private instance in private subnet
*/

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.cluster_name}-private-route-table"
  }

  depends_on = [aws_nat_gateway.nat]
}

resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.cluster_name}-public-route-table"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id
}
