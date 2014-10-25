vagrant-automation-machines
===========================

a boiler plate for automations relying on vagrant. simply clone and add files to "synced_folder" and a provision script.. 



# How to use 

In you automation do the following 

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
                 + ---------- ec2-aws/Vagrantfile
                 + ---------- hp/Vagrantfile
                 + ---------- softlayer/Vagrantfile
                 ...
 + /etc/sysconfig/ec2-aws.json // configuration file to ec2-aws/Vagrantfile
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
