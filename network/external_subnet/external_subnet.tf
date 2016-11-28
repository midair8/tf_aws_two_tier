variable "name_prefix" { }
variable "vpc_id"      { }
variable "multi_az"    { }
variable "azs"         { type = "list" }
variable "cidrs"       { type = "list" }

resource "aws_subnet" "ext" {
  count                   = "${var.multi_az}"
  vpc_id                  = "${var.vpc_id}"
  availability_zone       = "${element(var.azs, count.index % var.multi_az)}"
  cidr_block              = "${element(var.cidrs, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name_prefix}-ext-subnet-${element(var.azs, count.index % var.multi_az)}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name_prefix}-igw"
  }
}

resource "aws_route_table" "ext" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name_prefix}-ext-tbl"
  }
}

resource "aws_route" "ext_r" {
  route_table_id         = "${aws_route_table.ext.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table_association" "ext_a" {
  count          = "${var.multi_az}"
  subnet_id      = "${element(aws_subnet.ext.*.id, count.index)}"
  route_table_id = "${aws_route_table.ext.id}"
}

output "ids" {
  value = ["${aws_subnet.ext.*.id}"]
}
