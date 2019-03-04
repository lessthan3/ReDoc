#!/bin/bash

# install stand-alone gsutil
curl https://storage.googleapis.com/pub/gsutil.tar.gz --output gsutil.tar.gz
tar xfz gsutil.tar.gz -C $HOME
rm gsutil.tar.gz

export PATH=$HOME/gsutil:${PATH}
echo "$service_account_creds" > account.json

cat << BOTO > .boto
[Credentials]
gs_service_key_file = account.json
[Boto]
https_validate_certificates = True
[GoogleCompute]
[GSUtil]
content_language = en
default_api_version = 2
default_project_id = lessthan3
[OAuth2]
BOTO

export BOTO_CONFIG=$(pwd)/.boto
gsutil version -l

gsutil -m cp -r bundles gs://developers.maestro.io/docs/
gsutil -m acl ch -r -g all:R  gs://developers.maestro.io/docs/
rm account.json
rm .boto