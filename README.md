vagrant-automation-machines
===========================

a boiler plate for automations relying on vagrant. simply clone and add files to "synced_folder" and a provision script..

### Features

 - support for aws, hp, docker, softlayer
 - synced folder - from host to guest machine
 - external configuration
 - environment variables support
 - copy files from guest to host



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
 + ------ configurations
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
 - setup decrypted vagrant specific configuration file
 - setup provision script and files under synced_folder
 - run more scripts before vagrant ( pre_vagrant_hook.sh )
 - run `vagrant up --provider hp/aws-ec2/softlayer` 
    - work directory for this step should be set on the relevant folder
    - environment variable CONFIG_FILE should point to the decoded configuration file.
 - run more scripts after vagrant (post_vagrant_hook.sh )


## Creating your own `before` and `after` vagrant hooks

Sometimes there will be things you need to do right before vagrant runs, and things right after vagrant runs.

**For example**

 - write a encryption key to synced_folder. as an example - lets assume it is called encrypt_key.sh and contains:
 ```
 ENCRYPT_KEY="__the encrypt key__"
 ```
 - since this file is in synced_folder, the provision script can reference it under /vagrant_data
 - the provision script can easily use this file to know how to encrypt/decrypt files by running `source /vagrant_data/encrypt_key.sh`
 - once vagrant is done, you will want to delete this key by simply running `rm -rf synced_folder/encrypt_key.sh`


## Environment Variables Feature

Vagrant does not allow you to define environment variables in guest machine.

However, if you define `environmentVariable` in the configuration file, we will pass all keys & values to a file under `/vagrant/ENVIRONMENT_VARIABLES.sh`.

So for example if my configuration file includes:

```
{
    "environmentVariables": {
        "MY_KEY":"My Value"
    }
}

```

Then in the guest machine you will have a file `/vagrant/ENVIRONMENT_VARIABLES.sh` that contains the following content

```
MY_KEY="My Value"
```

In case you did not define any environment variables, this file will still exist but only empty.

So now, in your script, you can easily add the following lines of code

```
source /vagrant/ENVIRONMENT_VARIABLES.sh
```

To consume the environment variables you wanted.

To support other environments, you can simply write

```
source /vagrant/ENVIRONMENT_VARIABLES.sh || echo "no environment variables file.. skipping.. "
```

## How to copy files from guest to host

Based on [this gist](https://gist.github.com/geedew/11289350) we wrote a script to copy files back from the guest machine to the host machine. You can run it simply by writing 

```
pull_from_guest.sh /path/to/destination
```

and it will copy all files from guest at /vagrant_pull to the destination folder you chose
