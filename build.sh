#!/bin/bash

#[ ! -d ./layer/awscli ] && mkdir -p ./layer/awscli

# [ ! -d ./layer ] && mkdir -p ./layer

docker build -t awscli:amazonlinux .
CONTAINER=$(docker run -d awscli:amazonlinux false)
docker cp ${CONTAINER}:/layer.zip layer.zip
docker cp ${CONTAINER}:/AWSCLI_VERSION AWSCLI_VERSION


exit 0

CONTAINER=$(docker run -d awscli:amazonlinux false)
docker cp ${CONTAINER}:/opt/awscli/lib/python2.7/site-packages/ layer/awscli/
docker cp ${CONTAINER}:/opt/awscli/bin/ layer/awscli/
docker rm -f ${CONTAINER}


mv layer/awscli/site-packages/* layer/awscli/
cp layer/awscli/bin/aws layer/awscli/aws
# remove unnecessary files to reduce the size
rm -rf layer/awscli/pip* layer/awscli/setuptools* layer/awscli/awscli/examples

# install jq
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
mv jq-linux64 layer/awscli/jq
chmod +x layer/awscli/jq

# install CloudFoundry CLI
wget -O /etc/yum.repos.d/cloudfoundry-cli.repo https://packages.cloudfoundry.org/fedora/cloudfoundry-cli.repo
yum install -y cf-cli

# install Passwd to inject a password into CF CLI
yum install -y passwd

# cd layer; zip -r ../layer.zip *
