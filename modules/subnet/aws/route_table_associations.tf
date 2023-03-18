resource "aws_route_table_association" "route_to_internet" {
  for_each       = local.public_subnets
  subnet_id      = each.value.id
  route_table_id = try(aws_route_table.public_routing[0].id, "")
}
