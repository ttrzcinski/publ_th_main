variable "instance_type" {
  default = "t3.micro"
  type    = string
}
variable "subnet" {
  default = ""
  type    = string
}
variable "name" {
  default = ""
  type    = string
}
data "aws_subnet" "subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet}"]
  }
}
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.subnet.id
  tags = {
    Name = "${var.name}"
  }
}
