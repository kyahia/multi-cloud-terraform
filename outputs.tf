output "public_subnets" {
  value = module.subnet_aws.public_nets
}
output "private_subnets" {
  value = module.subnet_aws.private_nets
}
output "private_subnet_ids" {
  value = module.subnet_aws.private_subnet_ids
}
