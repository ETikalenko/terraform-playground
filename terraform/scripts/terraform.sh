#!/bin/bash

if [[ $# -ge 2 ]] || [[ $# -eq 0 ]]; then
    echo "Wrong number of input arguments"
    exit 1
fi

if [[ $1 == "init" ]]; then
  apk --no-cache add curl
  cd terraform || exit 1
  if [[ $BRANCH_NAME == "prod" ]]; then
    env="prod"
  elif [[ $BRANCH_NAME == "master" ]]; then
    env="uat"
  elif [[ $BRANCH_NAME == "dev" ]]; then
    env="dev"
  else
    echo "No build in ${BRANCH_NAME} branch"
  fi
# not possible to parametrize in terraform backend, using partial configuration
  terraform init -backend-config="bucket=terraform-labs-bucket-${env}"

elif [[ $1 == "apply" ]]; then
# install curl and python for terraform gcloud module and run terraform apply
# terraform gcloud currently incompatible with python 3.9, install 3.8
  apk --no-cache add curl
  apk --no-cache add python3=3.8.10-r0 --repository=https://dl-cdn.alpinelinux.org/alpine/v3.12/main
  cd terraform || exit 1
  terraform apply -auto-approve
# destroy gcloud module which deploys app so that it works each apply
  terraform destroy -target module.deploy_appengine -auto-approve

else
  echo "Wrong input arguments"
fi