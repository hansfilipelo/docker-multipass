# docker-multipass

This is a small bash script wrapper around [multipass](https://multipass.run/) which spawns a VM with docker inside of it. Intended target platform is macOS. This utility started out as a fork of docker-multipass from [chrisgoffinet](https://githubplus.com/chrisgoffinet/docker-multipass).

## Prerequisites

docker-multipass needs multipass, docker and make. Easiest way to get them is to use a package manager like homebrew.

```bash
$ brew install multipass docker make
```

## Install

First install with make.

```bash
PREFIX=/path/to/install/folder make install
```

## Create a VM for use with docker

```
docker-multipass create  # See -h for help
```

The `create` subcommand will print an export that can be added to your profile. Add it to profile (.zprofile for macOS default zsh) and then use `docker` as usual.

## How do I configure disk, memory, and cpu?

You can pass disk, memory, CPU, image and name of VM on the command line to `docker-multipass create` on a per-call basis, but the intended usecase is to only have one docker host which is configured in the file `$HOME/.docker-multipass-config`. An example configuration can be found below.

```
memory=4096M
cpus=4
disk=40G
vm_name=docker-multipass
image=lts
```
