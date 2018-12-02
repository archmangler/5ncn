provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  version = "~> 1.32"
}

module "vpc" {
  #source    = "../modules/vpc"
  source    = "git@github.com:archmangler/tvpc.git"
  stack_name          = "devops"
  environment  ="development"
  vpc_cidr = "${var.5ncn_vpc_cidr}"
  public_subnets = ["${var.public_subnet1}"]
  private_subnets = ["${var.private_subnet1}"]
  region = "${var.region}"
  key_name = "${var.key_name}"
}

#SGs for the CI/CD network
resource "aws_security_group" "cluster_inbound_sg" {
  name        = "cicd_inbound"
  description = "Allow SSH, HTTP/S from CI/CD servers only"
  vpc_id      = "${module.vpc.vpc_id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443 
    to_port     = 443
    protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
   from_port   = 8
   to_port     = 0
   protocol    = "icmp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

/*Cluster Master/Controller Node*/
/*
resource "aws_instance" "cluster_master" {
  ami                         = "${lookup(var.ami, var.region)}"
  instance_type               = "${var.cluster_master_instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.vpc.public_subnet_ids[0]}"
  private_ip                  = "${var.cluster_master_instance_ips[0]}"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [
    "${aws_security_group.cluster_inbound_sg.id}",
  ]
  tags {
    Name = "cluster-master-${format("%03d", count.index + 1)}"
  }
  count = "${length(var.cluster_master_instance_ips)}"
}
*/

/*Cluster Slave/Worker Node*/
resource "aws_instance" "cluster_slave" {
  ami                         = "${lookup(var.ami, var.region)}"
  instance_type               = "${var.cluster_slave_instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.vpc.public_subnet_ids[0]}"
  private_ip                  = "${var.cluster_slave_instance_ips[count.index]}"
  user_data                   = "${file("files/cluster_slave_bootstrap.sh")}"
  associate_public_ip_address = "false"
  vpc_security_group_ids = [
    "${aws_security_group.cluster_inbound_sg.id}",
  ]
  tags {
    Name = "cluster-slave-${format("%03d", count.index + 1)}"
  }
  count = "${length(var.cluster_slave_instance_ips)}"
}
