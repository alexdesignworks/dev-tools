#!/bin/bash
#
# Rebuild vagrant VM from local box and run Drupal updates.
#
# - destroys existing VM
# - provisions new VM
#

function countdown
{
        local OLD_IFS="${IFS}"
        IFS=":"
        local ARR=( $1 )
        local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
        local START=$(date +%s)
        local END=$((START + SECONDS))
        local CUR=$START

        while [[ $CUR -lt $END ]]
        do
                CUR=$(date +%s)
                LEFT=$((END-CUR))

                printf "\r%02d:%02d:%02d" \
                        $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))

                sleep 1
        done
        IFS="${OLD_IFS}"
        echo "        "
}

# Check for Vagrantfile to make sure we are in the right path.
if [ ! -e ./Vagrantfile ] ; then
  echo "This can only be run from the same path as your Vagrantfile"
  echo "  ie: cd ~/Projects/vagrant/ && ./scripts/vagrant-update-all.sh"
  exit 1
else
  # If we are in the right path, destroy everything.
  echo "Destroying VM in 5 seconds"
  countdown "00:00:05"
  vagrant destroy -f

  # On MacOSX sometimes virtualbox doesn't start properly on reboot
  # Mavericks seems to have changed startup commands or something
  # so if we are on MacOSX (Darwin) and /dev/vboxnetctl doesn't exist
  # we need to restart virtualbox.
  if [ "`uname -a | grep Darwin`" ] && [ ! -e /dev/vboxnetctl ] ; then
    echo "Restarting VirtualBox to reload kernel module"
    sudo /Library/StartupItems/VirtualBox/VirtualBox restart
  fi

  echo "Provisioning new VM"
  vagrant up

  vagrant ssh --command="cd /var/www/app && drush cc all && drush updb -y && drush vset maintenance_mode 0"

  vagrant ssh
fi
