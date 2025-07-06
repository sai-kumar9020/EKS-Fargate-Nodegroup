#Provider
provider "aws" {
  region = var.region
}
 
# VPC and Networking
resource "aws_vpc" "demo-vpc-uc19" {
cidr_block = var.vpc_cidr
  tags = {
    Name = "demo-vpc-uc19"
  }
}

#Creation Internet Gateway
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.demo-vpc-uc19.id
  tags = {
    Name = "demo-vpc-uc19-igw"
  }
}

#Create EIP
resource "aws_eip" "eip" {
  tags = {
    Name = "demo-vpc-uc19-eip"
  }
}

#Create Nat gateway
resource "aws_nat_gateway" "demo-natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "demo-vpc-uc2-nat-gw"
  }
}

#Creation Public Subnet
resource "aws_subnet" "public_subnet" {
  count             = 2
  vpc_id = aws_vpc.demo-vpc-uc19.id
  cidr_block        = element(var.public_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

#Creation Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id = aws_vpc.demo-vpc-uc19.id
  cidr_block        = element(var.private_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

#Assigning Internet to Internet Gateway in Routes
resource "aws_route_table" "public_routes" {
vpc_id = aws_vpc.demo-vpc-uc19.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Assigning Internet to Nat Gateway in Routes
resource "aws_route_table" "private_routes" {
vpc_id = aws_vpc.demo-vpc-uc19.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.demo-natgw.id
  }
}

#Adding Public subnets in Subnet Association
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_routes.id
}

#Adding Private subnets in Subnet Association
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_routes.id
}

#Creating Security Group for EKS Cluster
resource "aws_security_group" "eks_clustersecurity_group" {
  name   = "eks_cluster"
  vpc_id = aws_vpc.demo-vpc-uc19.id
 
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "rds-sg"
  description = "Allow MySQL from Web SG"
  vpc_id      = aws_vpc.demo-vpc-uc19.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}