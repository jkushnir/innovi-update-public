#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

rm -rf innovi-update || true
mkdir innovi-update
cd innovi-update

sftp -o StrictHostKeyChecking=no innovi-update@ftp.agentvi.com << EOF
   cd innovi-update/artifacts/charts
   get *.tgz
   exit
EOF
tar -xvzf *.tgz
mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
helm upgrade innovi-core innovi-core
