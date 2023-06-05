variable "vpc_id" {}
variable "tags" {}
variable "subnets" {}
variable "env" {}
variable "name" {
    default = "docdb"
}
variable "allow_db_cidr" {}
variable "engine_version" {}
variable "kms_arn" {}
variable "port_number" {
    default = 27017
}




