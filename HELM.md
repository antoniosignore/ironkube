

On the toolbox install and run chartmuseum

#!/usr/bin/env bash
sudo yum -y update
sudo curl -O https://storage.googleapis.com/golang/go1.10.linux-amd64.tar.gz
sudo tar -xvf go1.10.linux-amd64.tar.gz
sudo mv go /usr/local
export PATH=$PATH:/usr/local/go/bin
curl -LO https://s3.amazonaws.com/chartmuseum/release/latest/bin/linux/amd64/chartmuseum
chmod +x ./chartmuseum
sudo mv ./chartmuseum /usr/local/bin

chartmuseum \
--debug \
--port=8088 \
--basic-auth-user="core" \
--basic-auth-pass="verimi" \
--storage="local" \
--storage-local-rootdir="./chartstorage"  \
--allow-overwrite \
&


fetch, search, lint, package   -> no connection to K8s

list, install, upgrade, delete, rollback

  helm upgrade --install 
