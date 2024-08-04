#!/bin/bash

# GENERAL
# Disable swap space
sudo swapoff -a
	
# Install Docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
	
# Add Kubernetes repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

# Update packages
sudo yum update -y

# Install kubeadm (kubelet kubeadm kubectl)
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Enable the service
sudo systemctl enable kubelet.service