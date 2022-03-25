# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Get the IP of the machine used for terraform execution
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_instance" "cka-node" {
  count         = 3                                   
  ami           = "ami-04505e74c0741db8d"             
  instance_type = "t3a.small"                         
  key_name      = aws_key_pair.cka.key_name 
  private_ip    = "172.31.0.1${count.index}"

  availability_zone = "us-east-1c"

  tags = {
    Name     = "cka-node-${count.index}"
  }

  vpc_security_group_ids = [
    "${aws_security_group.cka.id}",
  ]

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
}

# Key generated with: ssh-keygen -o -a 100 -t ed25519 -f ./cka-cluster
resource "aws_key_pair" "cka" {
  key_name   = "cka-cluster"
  public_key = file("./cka-cluster.pub")
}


resource "aws_security_group" "cka" {
  name        = "cka-cluster"
  description = "cka-cluster"

  tags = {
    Name = "cka-cluster"
  }
}

resource "aws_security_group_rule" "ssh" {

  security_group_id = aws_security_group.cka.id

  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
}

resource "aws_security_group_rule" "internal" {
  security_group_id = aws_security_group.cka.id

  type        = "ingress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 65535
  self = true
}

resource "aws_security_group_rule" "allow-internet-access" {
  security_group_id = aws_security_group.cka.id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
