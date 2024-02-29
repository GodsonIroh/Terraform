#Configure EC2 for application tier
resource "aws_instance" "Skytroopers-application-instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Skytroopers-priv-sub1.id
  key_name                    = "Skytroopers-kp"
  vpc_security_group_ids      = [aws_security_group.Skytroopers-sg2.id]
  associate_public_ip_address = false
  
  tags = {
    Name = "Skytroopers-application-instance"
  }
}


# Creating security group
resource "aws_security_group" "Skytroopers-sg2" {
  name        = "Security group for application tier"
  description = "Security group for application tier"
  vpc_id      = aws_vpc.Skytroopers-vpc.id

  tags = {
    Name = "Skytroopers-sg2"
  }
}

# Inbound rules
resource "aws_vpc_security_group_ingress_rule" "SSH2" {
  security_group_id = aws_security_group.Skytroopers-sg2.id
  cidr_ipv4         = aws_vpc.Skytroopers-vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "HTTP2" {
  security_group_id = aws_security_group.Skytroopers-sg2.id
  cidr_ipv4         = aws_vpc.Skytroopers-vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Outbound rules
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_2" {
  security_group_id = aws_security_group.Skytroopers-sg2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_2" {
  security_group_id = aws_security_group.Skytroopers-sg2.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_network_interface_sg_attachment" "SG-attachment2" {
  security_group_id    = aws_security_group.Skytroopers-sg2.id
  network_interface_id = aws_instance.Skytroopers-application-instance.primary_network_interface_id
}

resource "aws_network_interface" "Application-NI" {
  subnet_id       = aws_subnet.Skytroopers-priv-sub1.id
  private_ips     = ["10.0.1.100"]
  security_groups = [aws_security_group.Skytroopers-sg2.id]

  attachment {
    instance     = aws_instance.Skytroopers-application-instance.id
    device_index = 1
  }
}