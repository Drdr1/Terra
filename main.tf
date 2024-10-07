module "VPC" {
  source = "./VPC"
  cidr_block = var.vpc_cidr
  vpc_name = var.vpc_name
}

module "public1" {
  source                = "./SUBNET"
  vpc_id                = module.VPC.vpc_id
  subnet_cidr           = "10.0.1.0/24"
  availability_zone     = "us-east-1b"
  map_public_ip_on_launch = true
  subnet_name           = "public1"
  depends_on            = [module.VPC]
}

module "public2" {
  source                = "./SUBNET"
  vpc_id                = module.VPC.vpc_id
  subnet_cidr           = "10.0.3.0/24"
  availability_zone     = "us-east-1c"
  map_public_ip_on_launch = true
  subnet_name           = "public2"
  depends_on            = [module.VPC]
}

# Private Subnets
module "private1" {
  source                = "./SUBNET"
  vpc_id                = module.VPC.vpc_id
  subnet_cidr           = "10.0.2.0/24"
  availability_zone     = "us-east-1b"
  map_public_ip_on_launch = false
  subnet_name           = "private1"
  depends_on            = [module.VPC]
}

module "private2" {
  source                = "./SUBNET"
  vpc_id                = module.VPC.vpc_id
  subnet_cidr           = "10.0.4.0/24"
  availability_zone     = "us-east-1c"
  map_public_ip_on_launch = false
  subnet_name           = "private2"
  depends_on            = [module.VPC]
}
module "igw" {
  source = "./IGW"
  igw_name = var.igw_name
  vpc_id = module.VPC.vpc_id
}
module "ngw" {
  source = "./NGW"
  ngw_name = var.ngw-name
  public_subnet_id = module.public1.subnet_id
}
module "puplic_route" {
    source = "./PUB_ROUTE"
    igw_id = module.igw.igw_id
    route_name = var.route_name
    subnet_ids = [module.public1.subnet_id,module.public2.subnet_id]
    vpc_id = module.VPC.vpc_id
  
}
module "private_route" {
  source = "./PRI_ROUTE"
  ngw_id = module.ngw.nat_gw_id
  subnet_ids = [module.private1.subnet_id,module.private2.subnet_id]
  vpc_id = module.VPC.vpc_id
  route_name = var.route-name
}
module "ec2-sg" {
  source = "./SG"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_from_port = 22
  ingress_protocol = "tcp"
  sg_name = "ec2-sg"
  vpc_id = module.VPC.vpc_id
  ingress_to_port = 22
  depends_on            = [module.VPC]
}
module "nginx-sg" {
  source = "./SG"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_from_port = 80
  ingress_protocol = "tcp"
  sg_name = "nginx-sg"
  vpc_id = module.VPC.vpc_id
  ingress_to_port = 80
  depends_on            = [module.VPC]
}
module "public_instances" {
  source         = "./EC2"
  instance_count = 1
  ami_id          = var.ami_id
  associate_public_ip_address = true
  instance_type   = var.instance-type
  subnet_ids      = [module.public1.subnet_id]
   security_group_ids = [module.nginx-sg.security_group_id , module.ec2-sg.security_group_id]
  key_name        = var.key_name
  instance_name   = "bastion-host"
}
module "private_instances" {
  source         = "./EC2"
  instance_count = 2
  associate_public_ip_address = false
  ami_id          = var.ami_id
  instance_type   = var.instance-type
  subnet_ids      = [module.private1.subnet_id,module.private2.subnet_id]
  security_group_ids = [ module.ec2-sg.security_group_id , module.nginx-sg.security_group_id]
  key_name        = var.key_name
  user_data       = <<-EOF
                    #!/bin/bash
                    sudo apt update
                    sudo apt install -y nginx
                    echo "TERRAFORM_PROJRCT "  > /var/www/html/index.html
                    sudo systemctl start nginx
                    sudo systemctl enable nginx
                    sudo service nginx restart 
                    EOF
  instance_name   = "private"
}
module "load_balancer" {
  source             = "./LB"
  lb_name             = "DR_lb"
  internal           = false
  subnet_ids         = [module.public1.subnet_id,module.public2.subnet_id]
  security_group_ids = [module.nginx-sg.security_group_id]
  target_group_name  = "DR_tg"
  target_group_port  = 80
  target_group_protocol = "HTTP"
  vpc_id             = module.VPC.vpc_id
  listener_port      = 80
  listener_protocol  = "HTTP"
  ec2_count     = 2
  ec2_ids       = module.private_instances.instance_ids
}
module "key" {
  source       = "./KEY_PAIR"
  e_nkind = "RSA"
  num_bits = 4096
  depends_on   = [module.VPC]
}