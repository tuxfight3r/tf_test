terraform {
  required_version = "~> 0.12.24"

  backend "local" {
    path = "../state_files/us-east-1.tfstate"
 }
}

provider "aws" {
  version = "~> 2.0"
  region = var.region
}

module "vpc" {
  source = "../modules/vpc"
  region = var.region
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr_blocks = var.public_cidr_blocks
  availability_zones = var.availability_zones
  project = var.project
  environment = var.environment
}

output "nginx_domain" {
  value = module.vpc.nginx_domain
}
