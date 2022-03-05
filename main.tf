module "AllDB" {
  count = length(var.DB)
  source = "./module"
  bucket = var.bucket
  key = var.key
  ENV = var.ENV
  INSTANCE_TYPE = var.INSTANCE_TYPE
  KEYPAIR_NAME = var.KEYPAIR_NAME
  component   = element(var.DB, count.index)
  PORT        = element(var.PORTS, count.index)
}

