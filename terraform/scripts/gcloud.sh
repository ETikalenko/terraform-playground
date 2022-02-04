#!/bin/bash

if [[ $1 == "enable_apis" ]]; then
  gcloud services enable cloudresourcemanager.googleapis.com
  gcloud services enable iam.googleapis.com
  gcloud services enable appengine.googleapis.com
else
  cd ..
  gcloud components install beta --quiet
  gcloud beta app deploy app_${BRANCH_NAME}.yaml
fi
