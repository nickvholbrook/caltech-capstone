terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.55.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_ami_ids" "ubuntu" {
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
  }
}

resource "aws_instance" "controlplane1" {
  ami = data.aws_ami.ubuntu.id
  #ami           = "ami-0a244485e2e4ffd03"
  instance_type = "t2.medium"
  key_name      = "k8s-keypair"
  tags = {
    name = "controlplane1"
  }

  user_data =<<EOF
#!/bin/bash
sudo hostname "controlplane" 
sudo apt-get update -y
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt install -y kubeadm=1.20.5-00 kubelet=1.20.5-00 kubectl docker.io

EOF

}

resource "aws_instance" "controlplane2" {
  ami = data.aws_ami.ubuntu.id
  #ami           = "ami-0a244485e2e4ffd03"

  instance_type = "t2.medium"
  key_name      = "k8s-keypair"
  tags = {
    name = "controlplane2"
  }

  user_data =<<EOF
#!/bin/bash
sudo hostname "controlplane" 
sudo apt-get update -y
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt install -y kubeadm=1.20.5-00 kubelet=1.20.5-00 kubectl docker.io

EOF

}


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

