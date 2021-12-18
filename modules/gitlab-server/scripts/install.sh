#install and configure the neccessary dependencies
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

#add GitLab package repository
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash


#reconfigure the gitlab-ctl
sudo gitlab-ctl reconfigure

#get the latest version of paostgres
sudo gitlab-ctl pg-upgrade

#restart gitlab-ctl
sudo gitlab-ctl restart

#the URL at which you want to access your GitLab instance
#sudo EXTERNAL_URL="http://35.229.127.112" apt-get install gitlab-ce
  
    
  

