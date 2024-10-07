variable "instance_name" {
  
}
variable "instance_count" {
  type = number
}
variable "ami_id" {
  
}
variable "instance_type" {
  
}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "key_name" {
  
}
variable "user_data" {
  default = ""
}
variable "associate_public_ip_address" {
  type = bool
  default = false
}
variable "key" {
  default = "./TF_key.pem"
}
