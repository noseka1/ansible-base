data "aws_availability_zones" "zones" {}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.cluster_name
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.zones.names
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  intra_subnets        = var.intra_subnets
  enable_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/nlb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-nlb"           = "1"
  }
}

resource "aws_security_group" "remote_access" {
  name_prefix = "${var.cluster_name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "${var.cluster_name}-remote" }
}
