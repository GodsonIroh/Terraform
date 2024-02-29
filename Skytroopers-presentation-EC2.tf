#Configure EC2 for presentation tier
resource "aws_instance" "Skytroopers-presentation-instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Skytroopers-pub-sub1.id
  key_name                    = "Skytroopers-kp"
  vpc_security_group_ids      = [aws_security_group.Skytroopers-sg1.id]
  associate_public_ip_address = true
  user_data                 = file("./apache.sh")
 
  tags = {
    Name = "Skytroopers-presentation-instance"
  }
}
#Creating a key pair
resource "aws_key_pair" "Skytroopers-kp" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

#Generating a private key 
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Saving the key pair in your local computer
resource "local_file" "Skytroopers-kp" {
  content = tls_private_key.rsa.private_key_pem
  filename = var.filename
}

# Creating security group
resource "aws_security_group" "Skytroopers-sg1" {
  name        = "Security group for presentation tier"
  description = "Security group for presentation tier"
  vpc_id      = aws_vpc.Skytroopers-vpc.id

  tags = {
    Name = "Skytroopers-sg"
  }
}

# Inbound rules
resource "aws_vpc_security_group_ingress_rule" "SSH1" {
  security_group_id = aws_security_group.Skytroopers-sg1.id
  cidr_ipv4         = aws_vpc.Skytroopers-vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "HTTP1" {
  security_group_id = aws_security_group.Skytroopers-sg1.id
  cidr_ipv4         = aws_vpc.Skytroopers-vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Outbound rules
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_1" {
  security_group_id = aws_security_group.Skytroopers-sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_1" {
  security_group_id = aws_security_group.Skytroopers-sg1.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
