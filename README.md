vagrant-automation-machines
===========================

a boiler plate for automations relying on vagrant. simply clone and add files to "synced_folder" and a provision script..

### Features

 - support for aws, hp, docker, softlayer
 - synced folder - from host to guest machine
 - external configuration
 - environment variables support with auto-detection
 - copy files from guest to host
 - ip resolution
 - nodejs support



# How to use 

___Make Sure To Install The Plugin For Each Cloud___

Before you start, go into the vagrant file you plan to use and look at the top. 

We document the plugin you need to install before you can run `vagrant up`. 

Don't miss this step or you will not succeed. 

___Usage Steps___
In your automation do the following 

 - Write a YAML/JSON configuration file and place it on your machine
    - The configuration file should follow the specific vagrant file's requirements. 
 - Clone this git repository
 - Clone/Checkout/copy files to be synced under "synced_folder" and a provision.sh script. 
 - Define an environment variable to define where the YAML/JSON configuration file is located
 - run `vagrant up` using the suitable vagrant configuration's folder as root to this step

### Encrypt your configuration file

we recommend you to encrypt your configuration and only decrypt it temporarily while the automation is running and the remove the decrypted version. 

# Structure of automation workspace

If you followed the instructions correctly, you should have the following folder structure 

```
 + automation root
 + ------ synced_folder // files to be synced should be here
 + ------ provision.sh // this is a file you placed here.. 
 + ---------- aws/Vagrantfile
 + ---------- hp/Vagrantfile
 + ---------- softlayer/Vagrantfile
   ...
 + /etc/sysconfig/aws.json // configuration file to ec2-aws/Vagrantfile
 + /etc/sysconfig/hp.json      // configuration file to hp/Vagrantfile
 ... 
```


Your automation should have the following steps

 - clone this repository
 - setup decrypted vagrant specific configuration file and set location to `CONFIG_FILE`
 - setup provision script and files under synced_folder
 - run `vagrant up --provider hp/aws/...` 
    - work directory for this step should be set on the relevant folder
    - environment variable CONFIG_FILE should point to the decoded configuration file.


## Environment Variables Feature

Vagrant does not allow you to define environment variables in guest machine.

However, if you define `environmentVariable` in the configuration file, we will pass all keys & values to a file under `/etc/ENVIRONMENT_VARIABLES.sh`.

So for example if my configuration file includes:

```
{
    "environmentVariables": {
        "MY_KEY":"My Value"
    }
}

```

Then in the guest machine you will have a file `/etc/ENVIRONMENT_VARIABLES.sh` that contains the following content

```
MY_KEY="My Value"
```

In case you did not define any environment variables, this file will still exist but only empty.

So now, in your script, you can easily add the following lines of code

```
source /etc/ENVIRONMENT_VARIABLES.sh
```

To consume the environment variables you wanted.

To support other environments, you can simply write

```
source /etc/ENVIRONMENT_VARIABLES.sh || echo "no environment variables file.. skipping.. "
```

### Using VAGRANT_ENV_ prefix

We also auto-detect environment variables that start with `VAGRANT_ENV_` and auto inject them under the `environmentVariables` section in your `CONFIG_FILE`

so running 

```bash 

export VAGRANT_ENV_VERSION="1.0.0"

```

would expose environment variable `VERSION` with value `1.0.0` in the guest machine. 

## How to copy files from guest to host

Based on [this gist](https://gist.github.com/geedew/11289350) we wrote a script to copy files back from the guest machine to the host machine. You can run it simply by writing 

```
../pull_from_guest.sh /path/to/destination
```

and it will copy all files from guest at /vagrant_pull to the destination folder you chose

please note you need to run this script from the same folder you ran `vagrant up`

## IP resolution

if you want to know the IP address for the machine you got, you can simply run script 

```
../get_ip.sh
```

please note you need to run this script from the same folder you ran `vagrant up`

# Configurable rsync excludes

Our project makes it even easier to exclude files from rsync.

By default, we ignore `.git` and `_site` folders.

If you want to configure the excludes, simply add a `.vagrantignore` file in your `synced_folder`

each line is a new entry for excludes.

Good to know - our project makes it seamless on what provider you are running. While on AWS plugin
the `excludes` parameter is different - but you don't have to worry about it.  [excludes with a single underscore character instead of two underscores like everyone else](https://github.com/mitchellh/vagrant-aws/issues/152)

# nodejs support

you can install this project globally with npm with `npm install -g cloudify-cosmo/vagrant-automation-machines`

and this will expose some useful command lines. 

## setup command

```bash 

pushd folder_with_provision_script_and_synced_folder
    vagrant-automation-machines-setup aws
    push aws
        vagrant up --provider aws
    popd
popd

```

The example above will copy directory `aws` and `util` which are necessary if you want to spin up a machine in aws-ec2. 


## copy from guest

this command assumes you have the vagrant-scp plugin installed. if it is not it will print an error. 

```bash

pushd folder_to_copy_to
    rm -rf reports # cleanup
    vagrant-automation-machines-copy reports # copy reports from guest to here.. 
popd

```


# Cleanup Best Practice

We found the easiest way to cleanup the environment in an automation was to use `trap` command in bash. 

For example: 

```bash

function cleanup(){
    vagrant destroy -f 
}

trap cleanup EXIT

vagrant up --provider=aws

```

This will make sure vagrant machine is destroyed before your script exits. 

