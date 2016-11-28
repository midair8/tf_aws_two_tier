variable "name_prefix"      { }
variable "vpc"              { }
variable "multi_az"         { }
variable "azs"              { type = "list" }
variable "external_subnets" { type = "list" }
variable "internal_subnets" { type = "list" }

module "vpc" {
  source = "./vpc"

  name_prefix = "${var.name_prefix}"
  cidr        = "${var.vpc}"
}

module "external_subnet" {
  source   = "./external_subnet"

  name_prefix = "${var.name_prefix}"
  vpc_id      = "${module.vpc.id}"
  multi_az    = "${var.multi_az}"
  azs         = "${var.azs}"
  cidrs       = "${var.external_subnets}"
}

module "nat" {
  source     = "./nat"

  multi_az   = "${var.multi_az}"
  subnet_ids = "${module.external_subnet.ids}"
}

module "internal_subnet" {
  source   = "./internal_subnet"

  name_prefix = "${var.name_prefix}"
  multi_az    = "${var.multi_az}"
  vpc_id      = "${module.vpc.id}"
  azs         = "${var.azs}"
  cidrs       = "${var.internal_subnets}"
  nat_ids     = "${module.nat.ids}"
}

output "vpc_id" {
  value = "${module.vpc.id}"
}

output "external_subnet_ids" {
  value = ["${module.external_subnet.ids}"]
}

output "nat_ids" {
  value = ["${module.nat.ids}"]
}

output "internal_subnet_ids" {
  value = ["${module.internal_subnet.ids}"]
}
