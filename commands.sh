#!/bin/bash
# Install Calico CNI
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Snapshot the ETCD database
ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshotdb

#Verify the snapshot:

ETCDCTL_API=3 etcdctl --write-out=table snapshot status snapshotdb

