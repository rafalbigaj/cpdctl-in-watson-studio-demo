#!/bin/bash

USERNAME=rafal.bigaj
APIKEY=tSH6J19tuWvVpTSp5jKIC2rAWcT2MXQLNDNJSgZb
URL=https://cpd-cpd-instance.apps.sap.ibm-cpd-partnerships.com

rm -rf bin
mkdir -p bin

CPDCTL_URL="https://github.com/IBM/cpdctl/releases/download/v1.1.269/cpdctl_linux_amd64.tar.gz"
echo "Downloading $CPDCTL_URL..."

wget -q $CPDCTL_URL
tar xzf cpdctl_linux_amd64.tar.gz -C bin
rm cpdctl_linux_amd64.tar.gz

CPD_CLI_URL="https://github.com/IBM/cpd-cli/releases/download/v11.3.0/cpd-cli-linux-EE-11.3.0.tgz"
echo "Downloading $CPD_CLI_URL..."

wget -q $CPD_CLI_URL
tar xzf cpd-cli-linux-EE-11.3.0.tgz
rm cpd-cli-linux-EE-11.3.0.tgz
mv cpd-cli-linux-EE-*/* bin
rm -rf cpd-cli-linux-EE-*

JQ_URL="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
echo "Downloading $JQ_URL..."
wget -q $JQ_URL
mv jq-linux64 bin/jq
chmod +x bin/jq

export PATH=$PATH:$(pwd)/bin

cpdctl --version
cpd-cli version

# Configure cpd-cli
cpd-cli config users set $USERNAME --username $USERNAME --apikey $APIKEY
cpd-cli config profiles set default --user $USERNAME --url $URL

# Configure cpdctl
unset USER_ACCESS_TOKEN
cpdctl config profile set default --url $URL
cpdctl config context set default --username $USERNAME --apikey $APIKEY --profile default