output "nat_id"{
    value = try(aws_nat_gateway.nat[0].id, var.nat_id)
}