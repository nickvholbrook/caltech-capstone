terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}

resource "aws_instance" "controlplane" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
}

resource "aws_instance" "node1" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
}
