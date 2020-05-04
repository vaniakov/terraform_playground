variable "region" {
  default = "us-east-2"
  type = string
}
variable "bucket_name" {
  default = "tf-course-2020-05-04-ikova"
  type = string
}
variable "web_image_id" {
  default = "ami-0cebd9367bd2ef59f"
  type = string
}
variable "web_instance_type" {
  default = "t2.nano"
  type = string
}

variable "whitelist" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "web_max_size" {
  type = number
  default = 1
}

variable "web_min_size" {
  type = number
  default = 1
}

provider "aws" {
  profile = "terraform"
  region = var.region
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-2a"

  tags = {
    "Terraform" = true
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-2b"

  tags = {
    "Terraform" = true
  }
}

resource "aws_elb" "prod_web" {
  name            = "prod-web-lb"
  subnets         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups = [aws_security_group.prod_web.id]

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

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow http and https inbound and everything outbound."

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  ingress {
    from_port   = 433
    to_port     = 433
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.whitelist
  }

  tags = {
    "Terraform" = true
  }
}

resource "aws_launch_template" "prod_web" {
  name_prefix   = "prod-web"
  image_id      = var.web_image_id
  instance_type = var.web_instance_type
}

resource "aws_autoscaling_group" "prod_web" {
  availability_zones  = ["us-east-2a", "us-east-2b"]
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  desired_capacity    = 1
  max_size            = var.web_max_size
  min_size            = var.web_min_size

  launch_template {
    id      = aws_launch_template.prod_web.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "prod_web" {
  autoscaling_group_name = aws_autoscaling_group.prod_web.id
  elb                    = aws_elb.prod_web.id
}
