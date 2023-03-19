output "public_subnets" {
  value = local.public_subnets
}
output "private_subnets" {
  value = local.private_subnets
}
output "subnets" {
  value = aws_subnet.subnets
}
