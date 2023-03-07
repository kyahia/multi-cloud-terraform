output "vpc_id" {
    value = aws_vpc.vpc[local.vpc_keys[0]].id
}