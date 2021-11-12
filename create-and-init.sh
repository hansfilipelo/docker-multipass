#!/bin/sh
set -xe

MEM=4096M
CPUS=3
DISK=40G

echo "Creating and launching instance"
multipass launch --name docker -c $CPUS -m $MEM -d $DISK --cloud-init cloud-init.yml

echo "Mounting $HOME into remote instance: docker"
multipass mount ${HOME} docker:/Users/${USER}

DOCKER_INSTANCE=$(multipass info docker | grep IPv4 | awk '{split($0,a," "); print a[2]}')

echo "Success! in your bash profile add this:"
echo "export DOCKER_HOST=tcp://$DOCKER_INSTANCE:2375"
