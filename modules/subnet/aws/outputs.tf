output "public_subnets" {
    value = local.public_subnets
}
output "private_subnets" {
    value = local.private_subnets
}
output "subnets" {
  value = merge(local.private_subnets, local.public_subnets)
}