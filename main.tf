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
  ami           = "ami-0d729d2846a86a9e7"
  instance_type = "t2.micro"
}

# resource "aws_instance" "node1" {
#   ami           = "ami-0d729d2846a86a9e7"
#   instance_type = "t2.micro"
# }
