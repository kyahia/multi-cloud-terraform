resource "aws_route_table_association" "route_to_internet" {
  for_each = local.public_subnets
  subnet_id      = aws_subnet.subnets[each.value].id
  route_table_id = aws_route_table.public_routing.id
}

resource "aws_route_table_association" "route_to_nat" {
  for_each = local.private_subnets
  subnet_id      = aws_subnet.subnets[each.value].id
  route_table_id = aws_route_table.private_routing.id
}