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
output "sg_id" {
    value = aws_security_group.aws_sg.id
}