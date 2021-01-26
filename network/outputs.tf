output "aws_subnets_public" {
  value   = aws_subnet.pub_subnet.*.id
}

output "aws_subnets_private" {
  value   = aws_subnet.priv_subnet.*.id
}

output "vpc_id" {
  value  = aws_vpc.vpc.id
}