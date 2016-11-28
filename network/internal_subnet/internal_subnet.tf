variable "name_prefix" { }
variable "vpc_id"      { }
variable "multi_az"    { }
variable "azs"         { type = "list" }
variable "cidrs"       { type = "list" }
variable "nat_ids"     { type = "list" }

resource "aws_subnet" "int" {
  count                   = "${var.multi_az}"
  vpc_id                  = "${var.vpc_id}"
  availability_zone       = "${element(var.azs, count.index % var.multi_az)}"
  cidr_block              = "${element(var.cidrs, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.name_prefix}-int-subnet-${element(var.azs, count.index % var.multi_az)}"
  }
}

resource "aws_route_table" "int" {
  count  = "${var.multi_az}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name_prefix}-int-tbl-${element(var.azs, count.index % var.multi_az)}"
  }
}

resource "aws_route" "int_r" {
  count                  = "${var.multi_az}"
  route_table_id         = "${element(aws_route_table.int.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(var.nat_ids, count.index)}"
}

resource "aws_route_table_association" "int_a" {
  count          = "${var.multi_az}"
  subnet_id      = "${element(aws_subnet.int.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.int.*.id, count.index)}"
}

output "ids" {
  value = ["${aws_subnet.int.*.id}"]
}
