resource "aws_route_table_association" "route_to_nat" {
  for_each = var.private_subnet_ids # this will loop throught the keys (name) of each private subnet
  subnet_id      = try(each.value, "")
  route_table_id = try(aws_route_table.private_routing.id, "")
}
