terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.20.1"
    }
  }
}


provider "aws" {
  profile = "defaut"
  region  = "us-east-1"
}


resource "aws_vpc" "dev_vpc" {
    cidr_block = "190.160.0.0/16"
    instance_tenancy = "default"

    tags {
        Name = "dev-vpc"
        Environment = "dev"
    }
  
}


resource "aws_internet_gateway" "dev_igw" {
  vpc_id = "${aws_vpc.dev_vpc.id}"
}


resource "aws_subnet" "dev_subnet" {
  vpc_id     = "${aws_vpc.dev_vpc.id}"
  cidr_block = "190.160.1.0/24"

  tags = {
    Name = "dev-subnet-1"
    Environment = "dev"
  }
}


resource "aws_security_group" "aws_sg" {
    vpc_id = "${aws_vpc.dev_vpc.id}"
    name = "dev-sg"
    description = "dev-sg"
 
    ingress {
    
  }
  
}


resource "aws_lb" "lb_dev" {
  name               = "dev_lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = "${aws_security_group.aws_sg.id}"
  subnets            = "${aws_subnet.dev_subnet.id}"

  enable_deletion_protection = true

  tags = {
    Name = "dev-lb"
    Environment = "production"
  }
}