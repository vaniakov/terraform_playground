provider "aws" {
  profile = "terraform"
  region =  "us-east-2"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket        = "tf-course-2020-05-04-ikova"
  acl           = "private"
  force_destroy = true
}

resource "aws_default_vpc" "default" {}
