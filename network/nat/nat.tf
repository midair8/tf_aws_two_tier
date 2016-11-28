variable "multi_az"   { }
variable "subnet_ids" { type = "list" }

resource "aws_eip" "nat" {
  count = "${var.multi_az}"
  vpc   = true
}

resource "aws_nat_gateway" "default" {
  count         = "${var.multi_az}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(var.subnet_ids, count.index)}"
}

output "ids" {
  value = ["${aws_nat_gateway.default.*.id}"]
}
