#!/usr/bin/env bash
set -e

pre_installation(){

echo "#################starting pre-installation #####################"

echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx-stable.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C
sudo apt-get update

}

installing_nginx(){
echo "################# installing nginx  #####################"
sudo apt-get -y install nginx
}

starting_nginx_server(){

echo "################# starting nginx server #####################"
service nginx restart > /dev/null

}

main(){

pre_installation
installing_nginx
starting_nginx_server

}

main