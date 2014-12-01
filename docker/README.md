# About

This implementation is from: https://github.com/bubenkoff/vagrant-docker-example

# Requirements

## Docker

 * You have to install docker. We used http://get.docker.io/ so we recommend this.
 * you need to add an image
 * Afterwards, to test your docker is working right, use `sudo docker run ubuntu`
 * then you can create an ubuntu container by simply running without vagrant `sudo docker run -t -i ubuntu /bin/bash`

## Setting up permissions

In order to make everything work properly, you must follow steps described in : http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo

Otherwise it will not work.

The gist of it is:

```
export USERNAME=__your username__
sudo groupadd docker
sudo gpasswd -a ${USERNAME} docker
sudo service docker restart
```

and then login/logout

## tmp folder permissions

if you are getting :

```
/opt/vagrant/embedded/lib/ruby/2.0.0/tmpdir.rb:34:in `tmpdir': could not find a temporary directory (ArgumentError)
```

this means you are lacking `/tmp` folder permissions and you should do
```
sudo chmod 1777 /tmp
```

## detaching from container

```
docker run -it ubuntu
^P^Q
docker attach [container_id]
```

## other helpful commands

Show all containers - also those you stopped
```
docker ps -a
```

Rerun a stopped container
```
docker start [container instance]
```

list all containers ID
```
docker ps -a -q
```

Delete all stopped containers
```
docker rm $(docker ps -a -q)
```

Start docker container with port forwarding
```
docker run -p 8080:8080 ubuntu
```