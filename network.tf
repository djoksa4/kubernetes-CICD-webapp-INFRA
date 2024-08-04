
#### VPC ######################################
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "kubernetes-vpc1"
  }
}

#### Subnet #########################################
resource "aws_subnet" "sn_pub_A" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.64/27"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-pub-A"
  }
}

#### Internet Gateway #################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "kubernetes-igw"
  }
}

#### Public Route Table setup #################################
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "kubernetes-pub-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

#### Associate subnet with route table
resource "aws_route_table_association" "sn_pub_A_assoc" {
  subnet_id      = aws_subnet.sn_pub_A.id
  route_table_id = aws_route_table.this.id
}