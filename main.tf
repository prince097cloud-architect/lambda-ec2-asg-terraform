module "asg_ec2_instance" {
  source             = "./Modules/asg"
  key_name           = var.key_name
  name               = var.name
  ami_id             = var.ami_id
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  instance_type      = var.instance_type
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids = [aws_security_group.asg_sg.id]
  depends_on         = [aws_security_group.asg_sg]
}


resource "aws_security_group" "asg_sg" {
  name        = "asg-private-sg"
  description = "Security group for private ASG EC2"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow SSH from within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "scale_down_lambda" {
  source                     = "./Modules/lambda_scale_asg"
  lambda_function_name       = var.lambda_function_name
  asg_name                   = module.asg_ec2_instance.name
  desired_capacity           = var.desired_capacity
  lambda_schedule_expression = var.lambda_schedule_expression
}


