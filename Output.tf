# Getting all the necessary IDs

output "vpc_id" {
  value = aws_vpc.Skytroopers-vpc.id
}

output "Skytroopers-pub-sub1_id" {
  value = aws_subnet.Skytroopers-pub-sub1.id
}

output "Skytroopers-pub-sub2_id" {
  value = aws_subnet.Skytroopers-pub-sub2.id
}

output "Skytroopers-priv-sub1_id" {
  value = aws_subnet.Skytroopers-priv-sub1.id
}

output "Skytroopers-priv-sub2_id" {
  value = aws_subnet.Skytroopers-priv-sub2.id
}

output "Skytroopers-priv-sub3_id" {
  value = aws_subnet.Skytroopers-priv-sub3.id
}

output "Skytroopers-priv-sub4_id" {
  value = aws_subnet.Skytroopers-priv-sub4.id
}

output "Skytroopers-pub-rt_id" {
  value = aws_route_table.Skytroopers-pub-rt.id
}

output "Skytroopers-priv-rt_id" {
  value = aws_route_table.Skytroopers-priv-rt.id
}

output "Skytroopers-igw_id" {
  value = aws_internet_gateway.Skytroopers-igw.id
}

output "Skytroopers-eip_id" {
  value = aws_eip.Skytroopers-eip.id
}

output "Skytroopers-ngw_id" {
  value = aws_nat_gateway.Skytroopers-ngw.id
}
