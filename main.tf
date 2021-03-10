provider "aws" {
  region = "us-east-1"
}

# centos7 = ami-06cf02a98a61f9f5e
# centos8 = ami-01ca03df4a6012157

variable "aws_ami" {
  type    = string
  default = "ami-06cf02a98a61f9f5e"
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^ami-", var.aws_ami))
    error_message = "The aws_ami value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDp9bMARded99IjL703pATlN50vrzC/mXaLIYBk0Iy7FkAKTPpQU3/uFs3AriHFmdR2vanRouWQoonYC6kY/k/QPLkRzb3brBubA8Eqpt0oi9yF1bpi8uT8td4PhFg6Mbk4GLr1dztKffTIl0R0Po4/aA5BUoXyalpTlRra2EBeSzB0qWyUZTODPHwlsOU9IgQklknDTlMONxUcV0XGMGWpSrkJXXRGEIWQfeBBmgHsMwhSVKKTiDxKV/ryw3D3ryRrYVeyWksHHwpwJlxGh+TPdS4nCLu02NHOdfoZSSRpZmC2ecVsUZSDSPbkAJNMqmXmF9V45//wxPLTaYfQu1QpMUE1N0aPPK4yWls/qpIgxMAcoX8+xzUMruulHHgf6sCFhXzhvruMhDsitbBNHqQ5/WDMrYEmQmcJ6NfFEAnNpN6fLNPUqg706KgfDeZZSXvvgnMXU//JFMW/p+olBtrWs9TL2zEwkv7WLcuGiqsQKdKiWU507+gW9AFZ9w/HJ3ywV5+lRXKwebumLLwBsC5sR1f1oPLGiT8EKjbpdErJwuwoHKgZmEW9HW3j3dw+WrYD69aLxjQm95Oxx0/ZoGWr5s2NpiVlqii6W2WI6O1StZL5+qXV2PceJs3TBe4904LTC007Ibu4LWCSC8mPaZtWsXUH0NlWi8b7Sh8cY0pFuQ== ivan@MacBook-Pro.local"
}

variable "username" {
  type    = string
  default = "centos"
}

variable "key_name" {
  type    = string
  default = "scalr-iacp-key"
}

resource "aws_instance" "instance" {
  ami                         = var.aws_ami
  instance_type               = "t1.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    owner = "vaniakov95@gmail.com"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = var.public_key
}

output "public_ip" {
  description = "The public ip for ssh access"
  value       = "ssh ${var.username}@${aws_instance.instance.public_ip}"
}
