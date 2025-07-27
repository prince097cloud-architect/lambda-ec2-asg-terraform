variable "name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
