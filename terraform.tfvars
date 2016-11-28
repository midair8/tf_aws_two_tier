name_prefix = "ghe-training"

region     = "us-west-2"
vpc        = "10.10.0.0/16"
multi_az   = "2"

azs = [
  "us-west-2a",
  "us-west-2b"
]

external_subnets = [
  "10.10.64.0/26",
  "10.10.64.64/26"
]

internal_subnets = [
  "10.10.65.0/26",
  "10.10.65.64/26"
]

key_name   = "ec2_user"
public_key = "/Users/sato-hironori/Dropbox/.ssh/ec2.pub"

bastion_images = {
  us-west-2        = "ami-81f62ce1"
  # ap-northeast-1 = "ami-i14r1u2i"
}
bastion_flavor              = "t2.micro"
accepts_ssh_connection_for  = ["203.141.158.197/32"]
