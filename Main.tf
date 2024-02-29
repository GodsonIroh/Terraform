#Configure the vpc
resource "aws_vpc" "Skytroopers-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "Skytroopers-vpc"
  }
}

#Configure 2 Public and 2 Private Subnets
resource "aws_subnet" "Skytroopers-pub-sub1" {
  vpc_id     = aws_vpc.Skytroopers-vpc.id
  cidr_block = var.Pub_Sub1_cidr
  availability_zone = var.Pub_Sub1_availability_zone

  tags = {
    Name = "Skytroopers-pub-sub1"
  }
}

resource "aws_subnet" "Skytroopers-pub-sub2" {
  vpc_id     = aws_vpc.Skytroopers-vpc.id
  cidr_block = var.Pub_Sub2_cidr
 availability_zone = var.Pub_Sub2_availability_zone

  tags = {
    Name = "Skytroopers-pub-sub2"
  }
}

resource "aws_subnet" "Skytroopers-priv-sub1" {
  vpc_id     = aws_vpc.Skytroopers-vpc.id
  cidr_block = var.Priv_Sub1_cidr
  availability_zone = var.Priv_Sub1_availability_zone

  tags = {
    Name = "Skytroopers-priv-sub1"
  }
}

resource "aws_subnet" "Skytroopers-priv-sub2" {
  vpc_id     = aws_vpc.Skytroopers-vpc.id
  cidr_block = var.Priv_Sub2_cidr
  availability_zone = var.Priv_Sub2_availability_zone


  tags = {
    Name = "Skytroopers-priv-sub2"
  }
}

#Configure 2 Private Subnets for the Database
resource "aws_subnet" "Skytroopers-priv-sub3" {
  vpc_id     = aws_vpc.Skytroopers-vpc.id
  cidr_block = var.Priv_Sub3_cidr
  availability_zone = var.Priv_Sub3_availability_zone

  tags = {
    Name = "Skytroopers-priv-sub3"
  }
}

resource "aws_subnet" "Skytroopers-priv-sub4" {
  vpc_id     = aws_vpc.Skytroopers-vpc.id
  cidr_block = var.Priv_Sub4_cidr
  availability_zone = var.Priv_Sub4_availability_zone

  tags = {
    Name = "Skytroopers-priv-sub4"
  }
}

#Configure route tables
resource "aws_route_table" "Skytroopers-pub-rt" {
  vpc_id = aws_vpc.Skytroopers-vpc.id

  tags = {
    Name = "Skytroopers-pub-rt"
  }
}

resource "aws_route_table" "Skytroopers-priv-rt" {
  vpc_id = aws_vpc.Skytroopers-vpc.id

  tags = {
    Name = "Skytroopers-priv-rt"
  }
}

#Configure route tables association for public and private private subnets
resource "aws_route_table_association" "Skytroopers-pub-rta1" {
  subnet_id      = aws_subnet.Skytroopers-pub-sub1.id
  route_table_id = aws_route_table.Skytroopers-pub-rt.id
}
resource "aws_route_table_association" "Skytroopers-pub-rta2" {
  subnet_id      = aws_subnet.Skytroopers-pub-sub2.id
  route_table_id = aws_route_table.Skytroopers-pub-rt.id
}

resource "aws_route_table_association" "Skytroopers-priv-rta1" {
  subnet_id      = aws_subnet.Skytroopers-priv-sub1.id
  route_table_id = aws_route_table.Skytroopers-priv-rt.id
}

resource "aws_route_table_association" "Skytroopers-priv-rta2" {
  subnet_id      = aws_subnet.Skytroopers-priv-sub2.id
  route_table_id = aws_route_table.Skytroopers-priv-rt.id
}

resource "aws_route_table_association" "Skytroopers-priv-rta3" {
  subnet_id      = aws_subnet.Skytroopers-priv-sub3.id
  route_table_id = aws_route_table.Skytroopers-priv-rt.id
}

resource "aws_route_table_association" "Skytroopers-priv-rta4" {
  subnet_id      = aws_subnet.Skytroopers-priv-sub4.id
  route_table_id = aws_route_table.Skytroopers-priv-rt.id
}

resource "aws_route" "Public-route" {
  route_table_id            = aws_route_table.Skytroopers-pub-rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Skytroopers-igw.id
}

resource "aws_route" "Private-route" {
  route_table_id            = aws_route_table.Skytroopers-priv-rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.Skytroopers-ngw.id
}  

#Configure internet gateway
resource "aws_internet_gateway" "Skytroopers-igw" {
  vpc_id = aws_vpc.Skytroopers-vpc.id

  tags = {
    Name = "Skytroopers-igw"
  }
}

#Configure elastic ip for NAT gateway
resource "aws_eip" "Skytroopers-eip" {
  domain   = "vpc"

  tags = {
    Name = "Skytroopers-eip"
  }
}

#Configure NAT gateway
resource "aws_nat_gateway" "Skytroopers-ngw" {
  allocation_id = aws_eip.Skytroopers-eip.id
  subnet_id     = aws_subnet.Skytroopers-pub-sub1.id

  tags = {
    Name = "Skytroopers-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Skytroopers-igw]
}


