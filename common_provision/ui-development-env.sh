#!/usr/bin/env bash
set -e

##################################################################################
#                                                                                #
# modifications:                                                                 #
# create repository_path file which contains your repository path for wget use!  #
# see - downloading_repository() method                                          #
#                                                                                #
##################################################################################

pre_installation(){
rm -rf qa-project-installation
mkdir qa-project-installation
cd qa-project-installation
echo '### Updating apt-get ###'
sudo apt-get update

}

installing_softwear(){
echo '### Installing python-software-properties ###'
sudo apt-get -y install python-software-properties

echo '### Installing nodejs ###'
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get -y install nodejs # depends on python-software-properties

echo '### Installing gem ###'
#sudo aptitude install libgemplugin-ruby
sudo apt-get -y install rubygems
sudo apt-get update

echo '### Installing git! ###'
sudo apt-get -y install git

}

downloading_repository(){
echo '### downloading qa-project repository ##'
path=$(<repository_path)
wget $path
}

installing_and_running_unzip(){
echo "#################### update and clean source ######################"
sudo apt-get update
sudo apt-get clean
echo "#################### force installation ######################"
sudo apt-get -f -y install

echo "#################### dpkg something ######################"
sudo dpkg --configure -a
sudo apt-get -f -y install

echo "#################### installing zip unzip ######################"
sudo apt-get -y install zip unzip
echo "#################### running unzip ######################"
unzip -n master.zip

}

post_installation(){

echo "#################### cd to project ######################"
cd qa-project-master

echo "Installing global libraries"

echo "########## installing grunt #############" && sudo npm install -g grunt-cli

echo "######### installing bower #############" && sudo npm install -g bower

echo "######### installing compass ###########" && sudo gem install compass

sudo npm cache clean

echo "######## installing dependencies #########" && npm install

echo "######## installing front-end dependencies #########" && bower install

echo "####### compiling css ###########" && grunt


}

main(){
echo "Starting point"

pre_installation
installing_softwear
downloading_repository
installing_and_running_unzip
post_installation

}

main

echo "fin"