# Kubernetes on AWS EC2: https://www.golinuxcloud.com/setup-kubernetes-cluster-on-aws-ec2/

# Prerequisites

Allow TCP 6443 in


# Setup Cluster

sudo kubeadm init --node-name controlplane1 --control-plane-endpoint 18.169.181.201 --upload-certs 

# Setup .kube/config
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico CNI
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Snapshot the ETCD database
ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshotdb

#Verify the snapshot:

ETCDCTL_API=3 etcdctl --write-out=table snapshot status snapshotdb

KUBE


# Login to Docker registry
# See: https://stackoverflow.com/questions/49032812/how-to-pull-image-from-dockerhub-in-kubernetes
kubectl create secret docker-registry regcred --docker-username=nickholbrook --docker-password=<your-pword> --docker-email=nick.holbrook@gmail.com -n default

# Edit application.properties file in Java project to connect to MySql container