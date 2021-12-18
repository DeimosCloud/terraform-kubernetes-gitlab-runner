##################################
#### Company: Deimos
#### Author: Oluwatomisin Lalude
#### Reviewer: Oreoluwa Adegbite
####################################

#!/bin/bash

#Uninstall Docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc

#download gcloud
curl https://sdk.cloud.google.com | bash -s -- --disable-prompts

#Preinstall steps

sudo apt-get update -y

sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install Docker

sudo apt-get update -y

sudo apt-get install -y jq docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER
newgrp docker

# If you're running redis on port 6379, this is all you need to get started

docker run --rm --name redis-commander -d -p 8081:8081 rediscommander/redis-commander:latest

# Specify single host
docker run --rm --name redis-commander -d --env REDIS_HOSTS=10.10.20.30 -p 8081:8081 rediscommander/redis-commander:latest

#Authenticate Service Account
gcloud auth activate-service-account --key-file=sa.json --project=united-aura-232913
printf 'yes' | gcloud auth configure-docker
