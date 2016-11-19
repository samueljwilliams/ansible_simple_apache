#!/bin/bash

BOTO_FILE=~/.boto
SSH_PUB_KEY_FILE=./roles/aws_setup/files/apache_rsa.pub
ANSIBLE_SECRETS_FILE=./vars/secrets.yml

function getBotoHelp {
  echo ""
  echo "example configuration for $BOTO_FILE file:"
  echo ""
  echo "[profile apache]"
  echo "output = json"
  echo "region = us-west-2"
  echo "aws_access_key_id = abc123"
  echo "aws_secret_access_key = 123abc"
}

function getAnsibleAWSHelp {
  echo ""
  echo "Please create a secrets file at $ANSIBLE_SECRETS_FILE with the following variables:"
  echo ""
  echo "---"
  echo "aws_api_access_key: abc123"
  echo "aws_api_secret_access_key: 123abc"
}

if [ -f $BOTO_FILE ]; then
  if grep -q apache $BOTO_FILE; then
      echo "apache profile found in $BOTO_FILE"
    else
      echo "ERROR - apache profile was not found, please add the apache profile to your $BOTO_FILE file"
      getBotoHelp
      exit 0
    fi
else
  echo "ERROR - please create your $BOTO_FILE configuration file with the apache profile"
  getBotoHelp
  exit 0
fi

if grep -q ssh-rsa $SSH_PUB_KEY_FILE; then
  echo "SSH public key found in $SSH_PUB_KEY_FILE"
else
  echo "ERROR - Please add your SSH public key to $SSH_PUB_KEY_FILE"
  exit 0
fi

if [ -f $ANSIBLE_SECRETS_FILE ]; then
  echo "Secrets file found, everything is good to go"
else
  echo "Secrets file was not found, please create it"
  getAnsibleAWSHelp
  exit 0
fi

ansible-playbook -i inventories/localhost pb_provision.yml
ansible-playbook -i inventories/ec2.py pb_configure.yml