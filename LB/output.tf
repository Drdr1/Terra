output "dns_name" {
  value = aws_lb.LB.dns_name
}
output "lb_name" {
  value = aws_lb.LB.arn
}
output "target_group_arn" {
  value = aws_lb_target_group.TG.arn
}