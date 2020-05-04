variable "region" {
  type = string
}
variable "bucket_name" {
  type = string
}
variable "web_image_id" {
  type = string
}
variable "web_instance_type" {
  type = string
}

variable "whitelist" {
  type = list(string)
}

variable "web_max_size" {
  type = number
}

variable "web_min_size" {
  type = number
}

