output "public_subnet_id" {
    value = aws_subnet.subnets[local.public_subnet_names[0]].id
}
output "public_nets" {
    value = local.public_subnets
}
output "private_nets" {
    value = local.public_subnets
}
output "private_subnet_ids" {
    value = local.private_subnet_ids
}
output "private_subnet_id" {
    value = [for key, id in local.private_subnet_ids: id][0]
}