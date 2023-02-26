resource "aws_route_table_association" "route_to_internet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_routing.id
}

resource "aws_route_table_association" "route_to_nat" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_routing.id
}
