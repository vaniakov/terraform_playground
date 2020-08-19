provider "aws" {
  profile = "terraform"
  region =  "us-east-2"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "tf-course-2020-05-04-ikova-ff--dfa-df"
  acl    = "private"
}
