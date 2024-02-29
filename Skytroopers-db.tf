# Configure the RDS mysql database
resource "aws_db_instance" "Skytroopers-db" {
  allocated_storage         = 10
  db_name                   = "mydb"
  engine                    = "mysql"
  engine_version            = "8.0.36"
  instance_class            = "db.t3.micro"
  username                  = "Skytrooper"
  password                  = "kachi2021"
  skip_final_snapshot       = true
  vpc_security_group_ids    = ["${aws_security_group.Skytroopers-sg3.id}"]
  db_subnet_group_name      = "skytrooper-subgrp" 
  multi_az                  = false # Custom for SQL Server does support multi-az

  tags = {
    Name = "Skytrooper-db"
  }
}

resource "aws_db_subnet_group" "skytrooper-subgrp" {
  name       = "skytrooper-subgrp"
  subnet_ids = [aws_subnet.Skytroopers-priv-sub3.id,aws_subnet.Skytroopers-priv-sub4.id]

  tags = {
    Name = "skytrooper-subgrp"
  }
}



# Creating security group
resource "aws_security_group" "Skytroopers-sg3" {
  name        = "Security group for database tier"
  description = "Security group for database tier"
  vpc_id      = aws_vpc.Skytroopers-vpc.id

  tags = {
    Name = "Skytroopers-sg3"
  }
}

# Inbound rules
resource "aws_vpc_security_group_ingress_rule" "SSH3" {
  security_group_id = aws_security_group.Skytroopers-sg3.id
  cidr_ipv4         = aws_vpc.Skytroopers-vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "MYSQL" {
  security_group_id = aws_security_group.Skytroopers-sg3.id
  cidr_ipv4         = aws_vpc.Skytroopers-vpc.cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

# Outbound rules
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.Skytroopers-sg3.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.Skytroopers-sg3.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
