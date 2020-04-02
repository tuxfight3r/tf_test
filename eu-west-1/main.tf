terraform {
  backend "local" {
    path = "state_files/eu-west-1.tfstate"
 }
}

module "vpc" {
  source = "../modules/vpc"
  region = var.region
  vpc-cidr = var.vpc-cidr
  subnet-cidr-a = var.subnet-cidr-a
  subnet-cidr-b = var.subnet-cidr-b
  subnet-cidr-c = var.subnet-cidr-c
}
