output "nat_gw_id" {
  value       = aws_nat_gateway.ngw.id
}

output "elastic_ip_id" {
  value       = aws_eip.ngw.id
}