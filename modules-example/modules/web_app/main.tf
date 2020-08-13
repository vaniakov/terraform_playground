resource "aws_elb" "this" {
  name            = "${var.web_app}-web-lb"
  subnets         = var.subnets
  security_groups = var.security_groups

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"

  }

  tags = {
    "Terraform" = true
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.web_app}-web"
  image_id      = var.web_image_id
  instance_type = var.web_instance_type
}

resource "aws_autoscaling_group" "this" {
  availability_zones  = ["us-east-2a", "us-east-2b"]
  vpc_zone_identifier = var.subnets
  desired_capacity    = 1
  max_size            = var.web_max_size
  min_size            = var.web_min_size

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  elb                    = aws_elb.this.id
}
