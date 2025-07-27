variable "asg_name" {}
variable "lambda_function_name" {}
variable "lambda_schedule_expression" {
  description = "Cron expression (optional). Leave blank for manual trigger"
  default     = null
}
variable "desired_capacity" {
  description = "The ASG capacity to set"
}
