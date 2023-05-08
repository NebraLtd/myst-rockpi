#!/bin/bash
echo "updating myst"
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt install -y myst