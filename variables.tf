variable vpc_cidr {
  type        = string
  default     = "10.0.0.0/16"
  description = "This is the  cider block for the VPC"
}   

variable "region" {
  type = string
  default = "ap-south-1"
  description = "This is the region in which resources are created"
}

variable "environment" {
  type = string
  default = "prod"
  description = "This is the type of the environment"
  }