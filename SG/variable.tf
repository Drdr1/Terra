variable "vpc_id" {
  
}
variable "sg_name" {
  
}
variable "ingress_from_port" {
  type = number
}
variable "ingress_to_port" {
  type = number
}
variable "ingress_cidr_blocks" {
  type = list(string)
}
variable "ingress_protocol" {
  
}
