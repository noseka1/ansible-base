module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"

  key_name_prefix    = var.cluster_name
  create_private_key = true
}
