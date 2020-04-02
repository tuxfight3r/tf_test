variable "name" {
  type = string
  default = "Default"
  description = "Name of the VPC"
}

variable "project" {
  type        = string
  description = "Name of project this VPC is meant to house"
}

variable "environment" {
  type        = string
  description = "Name of environment this VPC is targeting"
}

variable "region" {
  type = string
  default = "eu-west-1"
  description = "Region of the vpc"
}

variable "vpc-cidr" {
  type = string
  default = "10.10.10.0/24"
  description = "VPC Cidr Block"
}

variable "public_subnet_cidr_blocks" {
  type        = list
  default     = ["10.10.10.0/27,10.10.10.32/27,10.10.10.64/27"]
  description = "List of public subnet CIDR blocks"
}

variable "availablity_zone" {
  type        = list
  default     = ["eu-west-1a","eu-west-1b","eu-west-1c"]
  description = "List of public subnet CIDR blocks"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags to attach to the VPC resources"
}

variable "images" {
  type = map
  default = {
    us-east-1 = "ami-50c0ea46"
    eu-west-1 = "ami-cdbfa4ab"
  }
}

variable "instance_count" {
  type = string
  default = "1"
}
