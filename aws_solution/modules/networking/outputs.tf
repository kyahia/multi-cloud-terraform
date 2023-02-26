output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
output "vpc_id" {
  value = aws_vpc.web_app_vpc.id
}
output "allow_http_sg_id" {
value = aws_security_group.allow_http.id
}
output "lb_dns_name" {
value = aws_elb.web_app_lb.dns_name
}

output "lb_name" {
value = aws_elb.web_app_lb.name
}
