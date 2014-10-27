## a generic script for automation


## pre vagrant hook
HOOK_FILE=pre_vagrant_hook.sh
if [ -f $HOOK_FILE ]
   chmod 755 $HOOK_FILE
   source $HOOK_FILE
fi

pushd $CLOUD_FOLDER
vagrant up --provider $VAGRANT_PROVIDER --provision
vagrant destroy

HOOK_FILE=post_vagrant_hook.sh
if [ -f $HOOK_FILE ]
   chmod 755 $HOOK_FILE
   source $HOOK_FILE
fi

