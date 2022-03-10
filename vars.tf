variable "bucket" {}
variable "key" {}
variable "ENV" {}
variable "component" {}
variable "INSTANCE_TYPE" {}
variable "KEYPAIR_NAME" {}
variable "DB" {
  default = ["rabbitmq", "mysql", "redis", "mongodb"]
}
variable "PORTS" {
  default = [5672, 3306, 6379, 27017]
}