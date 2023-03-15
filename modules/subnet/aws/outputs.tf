output "public_subnet_ids" {
    value = local.public_subnet_ids
}
output "private_subnet_ids" {
    value = local.private_subnet_ids
}
output "public_subnet_id" {
    value = [for key, id in local.public_subnet_ids: id][0]
}
output "private_subnet_id" {
    value = [for key, id in local.private_subnet_ids: id][0]
}