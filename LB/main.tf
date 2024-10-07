resource "aws_lb" "LB" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids

  tags = {
    Name = var.lb_name
  }
}

resource "aws_lb_target_group" "TG" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.LB.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }
}

resource "aws_lb_target_group_attachment" "TG-attachment" {
  count            = var.ec2_count
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = var.ec2_ids[count.index]
  port             = var.target_group_port
}