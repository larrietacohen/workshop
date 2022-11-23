#Main VPC
resource "aws_vpc" "workshop" {
  cidr_block = var.vpc
  enable_dns_hostnames = true
  tags = {
    Name = "workshop"
    Environment = var.env
  }
}

#Private Net1
resource "aws_subnet" "private-net1" {
  vpc_id     = aws_vpc.workshop.id
  cidr_block = var.private-net1
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-net1-us-east-1a"
    Environment = var.env
  }
}
#Private Net2
resource "aws_subnet" "private-net2" {
  vpc_id     = aws_vpc.workshop.id
  cidr_block = var.private-net2
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-net2-us-east-1b"
    Environment = var.env
  }
}

#Public Net1 
resource "aws_subnet" "public-net1" {
  vpc_id     = aws_vpc.workshop.id
  cidr_block = var.public-net1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-net1-us-east-1a"
    Environment = var.env
  }
}

#Public Net2
resource "aws_subnet" "public-net2" {
  vpc_id     = aws_vpc.workshop.id
  cidr_block = var.public-net1
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-net2-us-east-1b"
    Environment = var.env
  }
}

#InternetGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.workshop.id
}

#ElasticIP
resource "aws_eip" "nat_gateway" {
  vpc = true
  tags = {
    Name = "eip-workshop"
    Environment = var.env
  }
}

#Natgw workshop
resource "aws_nat_gateway" "NATgw-workshop" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public-net1.id
  tags = {
    Name = "natgw-workshop"
    Environment = var.env
  }
}

# Route Table Private
resource "aws_route_table" "rt-workshop-private" {
  vpc_id = aws_vpc.workshop.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw-workshop.id
  }
  tags = {
    Name = "rt-private-workshop"
    Environment = var.env
  }
}

#Route Table Public
resource "aws_route_table" "rt-workshop-public" {
  vpc_id = aws_vpc.workshop.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "rt-public-workshop"
    Environment = var.env
  }
}

#Route Table Associations
resource "aws_route_table_association" "rta-workshop-private-net1" {
  subnet_id = aws_subnet.private-net1.id 
  route_table_id = aws_route_table.rt-workshop-private.id
}

#Route Table Associations
resource "aws_route_table_association" "rta-workshop-private-net2" {
  subnet_id = aws_subnet.private-net2.id 
  route_table_id = aws_route_table.rt-workshop-private.id
}

#Route Table Associations
resource "aws_route_table_association" "rta-workshop-public-net1" {
  subnet_id = aws_subnet.public-net1.id
  route_table_id = aws_route_table.rt-workshop-public.id
}

#Route Table Associations
resource "aws_route_table_association" "rta-workshop-public-net2" {
  subnet_id = aws_subnet.public-net2.id
  route_table_id = aws_route_table.rt-workshop-public.id
}