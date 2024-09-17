/*
In order for nodes to connect to the control plane, they must have a public IP address 
and a route to an internet gateway or a route to a NAT gateway where they can use the public IP address of the NAT gateway.
Mainly done for private subnets to access to the internet for outbound communication (like downloading packages, updates),
*/

# creating a static IP for nat-gw
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat"
  }
}

/*
A NAT Gateway allows private instances to connect to the internet, 
while preventing external systems from initiating connections to the instances.

nat gateway should be in a subnet that will have default route to internet gateway
*/
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id

  tags = {
    Name = "${var.cluster_name}-nat"
  }

  # NAT Gateway relies on the Internet Gateway to route traffic
  depends_on = [aws_internet_gateway.igw]
}
