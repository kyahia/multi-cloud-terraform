resource "aws_route_table_association" "route_to_nat" {
  for_each = local.private_subnets_with_nat
  subnet_id      = aws_subnet.subnets[each.value].id
  route_table_id = aws_route_table.private_routing[0].id
}