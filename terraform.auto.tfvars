name                       = "ec2-lambda"
ami_id                     = "ami-0d0ad8bb301edb745"
desired_capacity           = 0
max_size                   = 3
min_size                   = 0
instance_type              = "t2.micro"
lambda_function_name       = "scale_down_asg"
lambda_schedule_expression = "cron(50 8 * * ? *)"