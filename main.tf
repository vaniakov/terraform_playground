provider "aws" {
  region = "us-east-1"
}

#resource "aws_s3_bucket" "bucket" {
#  bucket        = "omnibus-sources-ikova"
#  force_destroy = true
#  acl           = "private"
#}

#resource "aws_instance" "centos8" {
#  ami                         = "ami-01ca03df4a6012157"
#  instance_type               = "t1.micro"
#  associate_public_ip_address = true
#  key_name                    = "falcon9"
#
#  tags = {
#    owner = "vaniakov95@gmail.com"
#  }
#}

resource "aws_instance" "centos7" {
  ami                         = "ami-06cf02a98a61f9f5e"
  instance_type               = "t1.micro"
  associate_public_ip_address = true
  key_name                    = "falcon9"

  tags = {
    owner = "vaniakov95@gmail.com"
  }
}

output "centos7" {
  description = "The public ip for ssh access"
  value       = "ssh centos@${aws_instance.centos7.public_ip}"
}

#output "centos8" {
#  description = "The public ip for ssh access"
#  value       = "ssh centos@${aws_instance.centos8.public_ip}"
#}

resource "aws_key_pair" "ssh-key" {
  key_name   = "falcon9"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDd1fgYf6aOQ4Aee6fv8vtcqZIxyjlmZdSZ7LG4BHpGgmzflQTDXDtjj99VlHIl+cR6c529EHp9tu+oLp1CEz+JU/tHXPw5bRs9SHVIZ2u5Dgv5IO5jGxnezAO4bLaqlVxT8vUAeECNEEXDNhoEitCzKSXx61g9wDtUMEsp72E8VSsxG9OpvMFrcGZs7wJtt495mp5coMaxm/ob08QzqCBoVGo2LOdx3sMcx6zPuZ7saZtFskJZA73DMkgvn/ppdD3FtFiHRH8kJvHyOKpSkvf5i6GDYOn5AhYTlVbhYpcKiufFKmI1ZEBFkfjFVkTymy9Ezy2rvfgOWjcTe1xro56EYhONGJxbOm0lIJYNBWonhTk5GwS3QaBJabEpAVwn9zWMoeQ+ZOMA6eiVivyqkaYoShT8E09rBc5kICbvCLlFw7JEBpDoqLyiaIHZ/VNsDksx3FeGbIfFsE5rgvpHc+2e7c6im36509MhJum0m3jrW6/hK2Ur5QPGQNJiFFT0DvEdl4M7JAnYkeIpgtlQYzQfi9EIW/aClaPrpNJy5AeQKxjTsXyDxK44KVGin1Ga3p7qN4H5B1eAhEUYvBlYtQTPbKvZbFygq29Ehp0Ie+CZ3CGeJGqhu425Tx2IhBtK5mV325GPH75Fo3SQPJR6QWp72FPgBKaPbBg55BW8PMkdIw== ikova@falcon9"
}
