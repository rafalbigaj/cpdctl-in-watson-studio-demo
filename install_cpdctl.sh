#!/bin/bash

CPDCTL_URL="https://github.com/IBM/cpdctl/releases/download/v1.1.269/cpdctl_linux_amd64.tar.gz"

echo "Downloading $CPDCTL_URL..."

wget -q $CPDCTL_URL
tar xzf cpdctl_linux_amd64.tar.gz
rm cpdctl_linux_amd64.tar.gz

export PATH=$PATH:$(pwd)

cpdctl --version
