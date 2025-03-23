# VPC Module
module "vpc" {
  source          = "./modules/vpc"
  app_name        = var.app_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  environment     = var.environment
}

# Bastion Host Module
module "bastion" {
  source            = "./modules/bastion"
  app_name          = var.app_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnets[0] # Ensure at least one public subnet exists
  allowed_ssh_cidrs = var.allowed_ssh_cidrs        # ✅ Ensure this is defined in variables.tf
  instance_type     = var.instance_type
}


# Application Load Balancer Module
module "networking" {
  source              = "./modules/networking"
  app_name            = var.app_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  acm_certificate_arn = module.certificates.certificate_arn
}

module "certificates" {
  source       = "./modules/certificates"
  domain_names = ["petstore.bagishbek.com", "www.petstore.bagishbek.com"]
  alb_dns_name = module.networking.alb_dns_name
  alb_zone_id  = module.networking.alb_zone_id
}

# ECS Cluster & Services Module
module "ecs" {
  source                = "./modules/ecs"
  aws_region            = var.aws_region
  environment           = var.environment
  app_name              = var.app_name
  web_repository_url    = module.ecr.web_repository_url
  api_repository_url    = module.ecr.api_repository_url
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  web_tg_arn            = module.networking.ui_target_group_arn
  api_tg_arn            = module.networking.api_target_group_arn
  alb_security_group_id = module.networking.alb_security_group_id
  db_host_arn           = module.rds.db_host_arn
  db_user_arn           = module.rds.db_user_arn
  db_port_arn           = module.rds.db_port_arn
  db_password_arn       = module.rds.db_password_arn
  db_name_arn           = module.rds.db_name_arn
}

# Elastic Container Registry (ECR) Module
module "ecr" {
  source      = "./modules/ecr"
  environment = var.environment
  app_name    = var.app_name
}

module "rds" {
  source          = "./modules/rds"
  environment     = var.environment
  app_name        = var.app_name
  private_subnets = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  ecs_task_sg_id  = module.ecs.ecs_task_sg_id
}
