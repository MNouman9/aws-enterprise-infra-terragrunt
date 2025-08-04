output "vpc_id" {
  value = aws_vpc.default.id
}

output "private_subnets" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id
  ]
}

output "private_subnet_a" {
  value = aws_subnet.private_a.id
}

output "private_subnet_b" {
  value = aws_subnet.private_b.id
}

output "private_subnet_c" {
  value = aws_subnet.private_c.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]
}

output "public_subnet_a" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b" {
  value = aws_subnet.public_b.id
}

output "public_subnet_c" {
  value = aws_subnet.public_c.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
