variable "vpc_id" {
  
}
variable "lb_name" {
  
}
variable "internal" {
  default = false
  type = bool
}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "target_group_name" {
  
}
variable "target_group_protocol" {
  default = "HTTP"
}
variable "target_group_port" {
  default = 80
  type = number
}
variable "listener_port" {
  default = 80
  type = number
}
variable "listener_protocol" {
  default = "HTTP"
}
variable "ec2_count" {
  type = number
  default = 1
}
variable "ec2_ids" {
  type = list(string)
}

