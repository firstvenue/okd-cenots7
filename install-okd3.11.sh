#!/bin/sh
PUBLIC_HOST_NAME_OR_IP=$1
sudo yum -y update
sudo yum -y remove firewalld

sudo tee /etc/syconfig/syslinux<<EOF
SELINUX=permissive
SELINUXTYPE=targeted
EOF

sudo yum install -y yum-utils device-mapper-persistent-data lvm2 wget
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y  docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER

sudo mkdir /etc/docker /etc/containers
sudo tee /etc/containers/registries.conf<<EOF
[registries.insecure]
registries = ['172.30.0.0/16']
EOF
sudo tee /etc/docker/daemon.json<<EOF
{
   "insecure-registries": [
     "172.30.0.0/16"
   ]
}
EOF

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


if [ -z "$PUBLIC_HOST_NAME_OR_IP" ]
then
      oc cluster up
else
      oc cluster up --public-hostname=$PUBLIC_HOST_NAME_OR_IP
fi

oc cluster status
