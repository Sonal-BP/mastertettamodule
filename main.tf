provider "aws" {
  region = var.region
}

module "vpc" {
  source = "git@github.com:Sonal-BP/Terra-task-vpc.git"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "loadbalancer" {
  source = "git@github.com:Sonal-BP/Terra-task-autoscaling.git"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "autoscaling" {
  source = "git@github.com:Sonal-BP/Terra-task-loadbalancer.git"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  target_group_arn  = module.loadbalancer.alb_target_group_arn
  ami_id            = var.ami_id
  instance_type     = var.instance_type
}
