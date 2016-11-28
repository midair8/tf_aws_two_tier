variable "name_prefix"         { }
variable "region"              { }
variable "multi_az"            { }
variable "vpc_id"              { }
variable "external_subnet_ids" { type = "list" }
variable "internal_subnet_ids" { type = "list" }

variable "key_name"   { }
variable "public_key" { }

variable "bastion_image"  { }
variable "bastion_flavor" { }
variable "accepts_ssh_connection_for" { type = "list" }

module "bastion" {
  source = "./bastion"

  name_prefix = "${var.name_prefix}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${element(var.external_subnet_ids, 0)}"

  key_name   = "${var.key_name}"
  public_key = "${var.public_key}"

  image                      = "${var.bastion_image}"
  flavor                     = "${var.bastion_flavor}"
  accepts_ssh_connection_for = "${var.accepts_ssh_connection_for}"
}

output "bastion_id" {
  value = "${module.bastion.id}"
}
