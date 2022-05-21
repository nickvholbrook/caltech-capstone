

# Setup Cluster

sudo kubeadm init --node-name controlplane 

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

