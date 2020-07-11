#!/bin/sh

sudo yum -y update

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y  docker-ce docker-ce-cli containerd.io

sudo mkdir /etc/docker /etc/containers

sudo systemctl daemon-reload
sudo systemctl restart docker

sudo systemctl enable docker

echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar xvf openshift-origin-client-tools*.tar.gz
cd openshift-origin-client*/
sudo cp oc kubectl /usr/local/bin/

oc version
