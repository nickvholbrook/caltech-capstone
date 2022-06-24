# Kubernetes on AWS EC2: https://www.golinuxcloud.com/setup-kubernetes-cluster-on-aws-ec2/
# Repo: https://github.com/nickvholbrook/caltech-capstone.git

# Prerequisites

Allow TCP 6443 inbound via Security Group


# Setup Cluster

sudo kubeadm init --node-name controlplane1 --control-plane-endpoint <ip address> --upload-certs 

or

sudo kubeadm init --node-name controlplane1 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem

# Setup .kube/config
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico CNI
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Remove taint on controlplane node
kubectl taint nodes controlplane1 node-role.kubernetes.io/master-

# Clone repo
git clone https://github.com/nickvholbrook/caltech-capstone.git

# Snapshot the ETCD database
ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshotdb

#Verify the snapshot:

ETCDCTL_API=3 etcdctl --write-out=table snapshot status snapshotdb

KUBE


# Login to Docker registry
# See: https://stackoverflow.com/questions/49032812/how-to-pull-image-from-dockerhub-in-kubernetes
kubectl create secret docker-registry regcred --docker-username=nickholbrook --docker-password=<your-pword> --docker-email=nick.holbrook@gmail.com -n default

# Edit application.properties file in Java project to connect to MySql container

# User Authentication

mkdir ~/k8sadmin
openssl genrsa -out ~/k8sadmin/k8sadmin.key 2048
openssl req -new -key ~/k8sadmin/k8sadmin.key -subj "/CN=k8sadmin" -out ~/k8sadmin/k8sadmin.csr
kubectl apply -f k8sadmin-csr.yaml 
kubectl get csr csr-for-k8sadmin -o jsonpath='{.status.certificate}' | base64 --decode > ~/k8sadmin/k8sadmin.crt

# Run a Docker container locally
docker run --name payment-db -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mypass1234 -e MYSQL_DATABASE=paymentdb -e MYSQL_PASSWORD=mypass1234 -e MYSQL_USER=springuser -d mysql