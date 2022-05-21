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

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


# Install CP1

resource "aws_instance" "controlplane1" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name      = "k8s-keypair"
  tags = {
    name = "controlplane1"
  }

  user_data =<<EOF
#!/bin/bash
sudo hostname "controlplane1" 
sudo apt-get update -y
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt install -y kubeadm=1.20.5-00 kubelet=1.20.5-00 kubectl docker.io

EOF

}

# Install CP2
resource "aws_instance" "controlplane2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name      = "k8s-keypair"
  tags = {
    name = "controlplane2"
  }

  user_data =<<EOF
#!/bin/bash
sudo hostname "controlplane2" 
sudo apt-get update -y
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt install -y kubeadm=1.20.5-00 kubelet=1.20.5-00 kubectl docker.io

EOF

}

# Install EC2 Instance for HAProxy load balancer
resource "aws_instance" "lbhaproxy" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name      = "k8s-keypair"
  tags = {
    name = "lbhaproxy"
  }

  user_data =<<EOF
#!/bin/bash
sudo hostname "lbhaproxy" 
sudo apt-get update -y
sudo apt install haproxy

EOF

}


resource "aws_eip" "default" {
  instance = aws_instance.lbhaproxy.id
  vpc      = true
}
