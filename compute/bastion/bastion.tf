variable "name_prefix" { }

variable "vpc_id"                     { }
variable "key_name"                   { }
variable "public_key"                 { }
variable "subnet_id"                  { }
variable "image"                      { }
variable "flavor"                     { }
variable "accepts_ssh_connection_for" { type = "list" }

resource "aws_key_pair" "default" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key)}"
}

resource "aws_security_group" "bastion" {
  vpc_id      = "${var.vpc_id}"
  name        = "bastion"
  description = "allow incoming ssh connection"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = "${var.accepts_ssh_connection_for}"
  }

  ingress {
    protocol    = "icmp"
    from_port   = 8
    to_port     = 8
    cidr_blocks = "${var.accepts_ssh_connection_for}"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = "${var.image}"
  instance_type          = "${var.flavor}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  key_name               = "${aws_key_pair.default.id}"

  connection {
    user = "ec2-user"
  }

  tags {
    Name = "${var.name_prefix}-bastion"
  }
}

resource "aws_eip" "bastion" {
  vpc = true
}

resource "aws_eip_association" "bastion_a" {
  allocation_id = "${aws_eip.bastion.id}"
  instance_id   = "${aws_instance.bastion.id}"
}

output "id" {
  value = "${aws_instance.bastion.id}"
}

output "key_id" {
  value = "${aws_key_pair.default.id}"
}
