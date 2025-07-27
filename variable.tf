variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {
  default = null
}
variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}
# variable "vpc_id" {}
# variable "subnet_ids" {
#   type = list(string)
# }
# variable "security_group_ids" {
#   type = list(string)
# }
variable "lambda_function_name" {}
variable "lambda_schedule_expression" {}
