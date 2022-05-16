terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "controlplane" {
  ami           = "ami-0a244485e2e4ffd03"
  instance_type = "t2.medium"
  key_name = "k8s-keypair"
  hostname = "controlplane" 
  tags = {
    name = "controlplane"
  }

  user_data = <<EOF
  #!/bin/bash
  apt-get update -y
  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  apt-get update
  apt install -y kubeadm=1.20.5-00 kubelet=1.20.5-00 kubectl docker.io

  EOF

}

# resource "aws_instance" "node1" {
#   ami           = "ami-0a244485e2e4ffd03"
#   instance_type = "t2.micro"

#     tags = {
#     name = "node1"
#   }
# }



# resource "aws_lb" "test" {
#   name               = "k8s-loadbalancer"
#   internal           = false
#   load_balancer_type = "network"
#   subnets            = [for subnet in aws_subnet.public : subnet.id]

#   enable_deletion_protection = true

#   tags = {
#     Environment = "production"
#   }
# }

