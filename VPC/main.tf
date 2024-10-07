resource "aws_vpc" "VPC" {
  cidr_block = var.cidr_block


  tags = {
    Name = var.vpc_name
  }
}
