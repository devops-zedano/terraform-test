variable "AWS_REGION" {
  default = "us-west-2" # Oregon
}

variable "key_name" {
}

# Official CentOS Linux 7 image.
# Check README.md for the method of obtaining.
variable "ami_id" {
  default = "ami-0bc06212a56393ee1"
}

variable "vpc_id" {
}

variable "subnet_ids" {
  type = list(string)
}
