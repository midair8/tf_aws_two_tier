variable "cidr" { }
variable "name_prefix" {}

resource "aws_vpc" "default" {
  cidr_block = "${var.cidr}"

  tags {
    Name = "${var.name_prefix}-vpc"
  }
}

output "id" {
  value = "${aws_vpc.default.id}"
}
