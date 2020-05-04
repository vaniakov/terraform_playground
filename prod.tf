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

resource "aws_security_group" "web" {
  name        = "web"
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


module "web_app" {
  source            = "./modules/web_app"

  web_image_id      = var.web_image_id
  web_instance_type = var.web_instance_type
  web_max_size      = var.web_max_size
  web_min_size      = var.web_min_size
  subnets           = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups   = [aws_security_group.web.id]
  web_app           = "prod"
}
