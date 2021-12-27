#!/bin/bash -e

apt update && apt dist-upgrade -y

apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common \
  unattended-upgrades \
  lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list
apt update

apt install -y\
  docker-ce \
  docker-ce-cli \
  containerd.io

# Add default user to docker group
usermod -a -G docker ubuntu

# Disable flags to dockerd, all settings are done in /etc/docker/daemon.json
mkdir -p /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

# Enable IP forwarding
echo "net.ipv4.conf.all.forwarding=1" > /etc/sysctl.d/enabled_ipv4_forwarding.conf

mkdir -p /etc/docker
cat << EOF > /etc/docker/daemon.json
{
  "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]
}
EOF

systemctl daemon-reload
systemctl restart docker

cat unattended.conf > /etc/apt/apt.conf.d/50unattended-upgrades
