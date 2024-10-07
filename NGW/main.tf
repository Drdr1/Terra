resource "aws_eip" "ngw" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = var.public_subnet_id
  

  tags = {
    Name = var.ngw_name
  }
  depends_on    = [aws_eip.ngw]
}