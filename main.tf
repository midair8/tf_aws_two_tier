# network
variable "name_prefix"      { }
variable "region"           { }
variable "vpc"              { }
variable "multi_az"         { }
variable "azs"              { type = "list" }
variable "external_subnets" { type = "list" }
variable "internal_subnets" { type = "list" }

# credential
variable "key_name"   { }
variable "public_key" { }

# compute
variable "bastion_images" { type = "map"  }
variable "bastion_flavor" { }
variable "accepts_ssh_connection_for"  {
  type    = "list"
  default = ["0.0.0.0/0"]
}

provider "aws" {
  region = "${var.region}"
}

module "network" {
  source = "./network"

  name_prefix      = "${var.name_prefix}"
  vpc              = "${var.vpc}"
  multi_az         = "${var.multi_az}"
  azs              = "${var.azs}"
  external_subnets = "${var.external_subnets}"
  internal_subnets = "${var.internal_subnets}"
}

module "compute" {
  source = "./compute"

  name_prefix         = "${var.name_prefix}"
  region              = "${var.region}"
  vpc_id              = "${module.network.vpc_id}"
  multi_az            = "${var.multi_az}"
  external_subnet_ids = "${module.network.external_subnet_ids}"
  internal_subnet_ids = "${module.network.internal_subnet_ids}"

  key_name   = "${var.key_name}"
  public_key = "${var.public_key}"

  bastion_image              = "${lookup(var.bastion_images, var.region)}"
  bastion_flavor             = "${var.bastion_flavor}"
  accepts_ssh_connection_for = "${var.accepts_ssh_connection_for}"
}
