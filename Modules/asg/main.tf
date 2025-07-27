resource "aws_launch_template" "my_infra_template" {
  name_prefix = "${var.name}-template"
  image_id = var.ami_id
  instance_type = var.instance_type
}
resource "aws_autoscaling_group" "my_infra_asg" {
  name = var.name
  desired_capacity = var.desired_capacity
  min_size = var.min_size
  max_size = var.max_size
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id= aws_launch_template.my_infra_template.id
    version = "$Latest"
  }
   tag {
    key                 = "Name"
    value               = "${var.name}-instance"
    propagate_at_launch = true
  }
   lifecycle {
    ignore_changes = [desired_capacity]
  }
}