module "mongodb" {
  source = "./mongodb"
  bucket = var.bucket
  key = var.key
  ENV = var.ENV
  INSTANCE_TYPE = var.INSTANCE_TYPE
  KEYPAIR_NAME = var.KEYPAIR_NAME
  component   = var.component
}